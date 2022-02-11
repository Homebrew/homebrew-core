class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.4.tar.xz"
  sha256 "7fc3092855b5c2200cd9feed133d04605823f250d73b4d4ac501300370e0a0c2"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a7e68fb892c546e674671774713bf76d7be95154c610ec2793c926dd4ffa96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10eb8bb909b783bf629a33655d69136350ccc01f7639a604ee79c3f741eb618"
    sha256 cellar: :any_skip_relocation, monterey:       "fd10b9b391ef637d9449fccbcc5e135d28ba5a7276dc6ad9fa291f98d23ede30"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8adf8aada9d632b409cf8273ca71a54f3e34ec116d2bd67927ad2fda2df1cc8"
    sha256 cellar: :any_skip_relocation, catalina:       "917525edb84f0c1be727c07d6da89d62e5308bf5e92a682f0339440088660ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803dde375825c0e6943bb8c76d6d770fb2fe9a37f149c2f4761907bfd59fdfb7"
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
