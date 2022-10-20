class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.8.tar.xz"
  sha256 "0f5b65cdb60f78af41cb075c238983689a1e1f7e25c819f179862c18a484cf57"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cf315218fdfada493834f1e84e729398dbc49c72f2bc9df02c8159a8538038e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab63695ec5c202a239b56c0b2841665f27ce0e0f60c3e13b943d0fa3e790092"
    sha256 cellar: :any_skip_relocation, monterey:       "fd6df5f0e793848d5a89203204f57419e167dd5d5aa8ee59845614858f2e593a"
    sha256 cellar: :any_skip_relocation, big_sur:        "009ea313f3ec104f58778390548ddccf5fa411430ae063caec20b73bcf23c3b5"
    sha256 cellar: :any_skip_relocation, catalina:       "38369d24bd3fb20b0df187468198b615be6c99a25cc53cc17906d140f4f783e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd58b00a524ae51aff36a02c2e45b7ce379ce344059e413d6bf48f3c5931fc5"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

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
