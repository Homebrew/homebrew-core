class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.2.tar.xz"
  sha256 "9ac4714fa6c315d691da7f5d8941c1b190d4d437397d9742e327c2d51893e373"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7daaa6628706cef3ec4b193bbefdb0c3804dd7019841d01608eecca994448c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f2c52131f50e173728bbd873c32656e051c20b0d13a5a90ee1b4e59f6d746f8"
    sha256 cellar: :any_skip_relocation, monterey:       "26f0d2faa4867a8e614de4d7e433e0fa6a31747c27efd1787789140c77f4697f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d7228fccca15018d2315112e6fcbdef1026e73d19f158af49d19904e959c72c"
    sha256 cellar: :any_skip_relocation, catalina:       "3c6f4cb8efc2fa744f3bf5920bf5f3b031891fa700a4c41c2d421532a7aa2561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c04834ff02bde41a8fe8608fe1d547ce83be2603bb4864c97d84ee3568475e0"
  end

  depends_on "help2man" => :build

  def install
    if build.head?
      # this will clone https://github.com/nim-lang/csources_v1
      # at some hardcoded revision
      system "/bin/sh", "build_all.sh"
      # Build a new version of the compiler with readline bindings
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
    else
      system "/bin/sh", "build.sh"
      system "bin/nim", "c", "-d:release", "koch"
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
      system "./koch", "tools"
    end

    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      man1.install "#{t}.1"
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
