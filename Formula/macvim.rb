# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-153.tar.gz"
  version "8.1-153"
  sha256 "c8c18209d5dbfeaeeb69bd15723840a54507ba181a5fb790093fdfaed04846eb"
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    cellar :any
    sha256 "c2872f6c8bdbdf22c2ba0bf1258b6afa2193ba91db2b0f4fa4f9bae003e0c5a3" => :mojave
    sha256 "6f02b5bba24fc00329511b6865e0e869c4dd02091d1531475f12ed08858dd093" => :high_sierra
    sha256 "a5b06c8ae8b671aaf476be78f30053c998794b437979cea5e0a6af0816834434" => :sierra
  end

  depends_on :xcode => :build
  depends_on "cscope"
  depends_on "lua"
  depends_on "python"

  conflicts_with "vim",
    :because => "vim and macvim both install vi* binaries"

  def install
    # Avoid issues finding Ruby headers
    if MacOS.version == :sierra || MacOS.version == :yosemite
      ENV.delete("SDKROOT")
    end

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # If building for OS X 10.7 or up, make sure that CC is set to "clang"
    ENV.clang if MacOS.version >= :lion

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--with-macarchs=#{MacOS.preferred_arch}",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = Utils.popen_read("python3-config", "--exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
