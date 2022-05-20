class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.6.tar.xz"
  sha256 "67b111ce6f3861503b9fcc1cae59fc34d0122566d3ecfef3a064a2174121a452"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e214ca5ddbf7d42963f13f2cbab8c574cf21a8baf321d3ed3747f09f27bce76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2ef248de065620fdeb54db3faaf5082ec32d67734590074546c84facdb5be05"
    sha256 cellar: :any_skip_relocation, monterey:       "bf085cf759a3ecdd1e680e809f2cb73ac503d5951d34ed49c8b6927cc8a56024"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b149204287e7bbde1e80e2cc5829dffe94c158ac095324fe3bbbbc67abbacb9"
    sha256 cellar: :any_skip_relocation, catalina:       "de0fe0f7e2e0738cc72993964ac02364f73b9bdd8a832c8be353686336eabdbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c949ae021e7d3fea06f4738d58adea8cb0bc2b79031a5640cec1e80908f496"
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
