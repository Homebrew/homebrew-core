class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.0.4.tar.xz"
  sha256 "89841545a14475911bb84616bcd5a1b93a3268e1a6a0089f54642e405eeaaee0"

  bottle do
    cellar :any_skip_relocation
    sha256 "57e5c77f086a481fdd4419b35772c87ba26d7f49771ff684cd15ff59060944cd" => :catalina
    sha256 "16195369dfc2300edd6e58fb50b97964eff155bf139e8fd1ab09c58222488eeb" => :mojave
    sha256 "788b92daa9614b0a5a60b8cae441651a691774fa3a08b804d1bcc7b07a2d4384" => :high_sierra
  end

  head do
    url "https://github.com/nim-lang/Nim.git", :branch => "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
