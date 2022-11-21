# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-174.tar.gz"
  version "9.0.472"
  sha256 "9481eeca43cfc0a7cf0604088c4b536f274821adb62b0daefada978aa7f4c41b"
  license "Vim"
  revision 1
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "de5c5d8b02a4e5e88ce6f4c5ada027e494b7ad37f6e4d5be3a80a2f60e7243f4"
    sha256 arm64_monterey: "0f2f16662a0ab3a6b880e48d70c13ac1780813f80e46bf8def642978eddf1eb7"
    sha256 arm64_big_sur:  "1ad7f004dc4475d0b33dea8807e6a98b4b94c149e51242539197007e6d845fd1"
    sha256 ventura:        "9291a4bd874610b40b0595d04950b5f545294f88f8edca893ac52704b608cd23"
    sha256 monterey:       "010a07565e1d30f2df3d6897eaab3349d045229c40a3649ee34f91262744088e"
    sha256 big_sur:        "31235d0e38044b60a2b28c50f6045f315d4d4cb3ea30f270e7de0ea8231202d3"
    sha256 catalina:       "637151f7b70df77045daaf913be2865d169c1fa3ad605e172cbdbed42b595d8b"
  end

  depends_on xcode: :build
  depends_on "cscope"
  depends_on "gettext"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.11"
  depends_on "ruby"

  conflicts_with "vim", because: "vim and macvim both install vi* binaries"

  def install
    # Avoid issues finding Ruby headers
    ENV.delete("SDKROOT")

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # We don't want the deployment target to include the minor version on Big Sur and newer.
    # https://github.com/Homebrew/homebrew-core/issues/111693
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # make sure that CC is set to "clang"
    ENV.clang

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
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
                          "--enable-python3interp",
                          "--disable-sparkle",
                          "--with-macarchs=#{Hardware::CPU.arch}"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    # Remove autoupdating universal binaries
    (prefix/"MacVim.app/Contents/Frameworks/Sparkle.framework").rmtree
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output
    assert_match "+gettext", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = shell_output(Formula["python@3.11"].opt_libexec/"bin/python-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
