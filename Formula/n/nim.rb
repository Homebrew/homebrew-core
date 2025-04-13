class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.2.2.tar.xz"
  sha256 "7fcc9b87ac9c0ba5a489fdc26e2d8480ce96a3ca622100d6267ef92135fd8a1f"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0340ae372df6f2576a03ced8cf2b01d51cf297fac9a493b4aa2a416339661fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c16338f976e40751ea6f8ce76f5eab72f430f1a2d8a54ac50d9403f6d6a50f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "078694d8c799818a058d74fa382c11768aea9aef66f37d42d64ff5a580bcaf8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa7e2efb3883390c2a2b61c492b7585205b5bd093553fc37bb4b52d6dfde6a13"
    sha256 cellar: :any_skip_relocation, ventura:       "4ab3f16b347e8c8429dc9da97eda9840eb52b61013ead7e5357e5b55e102d98c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c74f2cb8701b6c9953ea5b35fb93a11055c853be635f7d5bebfe29ac1589a192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dae8e50a1e04461da0c654945051de206839b47510810c327b024284ae14cc7"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "atlas", "mongodb-atlas-cli", because: "both install `atlas` executable"

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
    tools = %w[nimble nimgrep nimpretty nimsuggest atlas testament]
    tools.each do |t|
      if t == "testament"
        system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N", "--no-discard-stderr"
      else
        system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      end

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
