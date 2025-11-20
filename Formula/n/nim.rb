class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.2.6.tar.xz"
  sha256 "657b0e3d5def788148d2a87fa6123fa755b2d92cad31ef60fd261e451785528b"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0688a91212a72fc992d8f31de012836cd9208ef8bde75d12e0bbcae16c09d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2089e5cf9fff042e85ccab2d0947331d498fe8f49340e39a15a8b5be997f9f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dd2909403de9a9ded249f6b53c49bffda04a8a0cc2461a7b1277d6ea2a4ccd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d365ff3b3902000c40f57d79c789c97fccb49ef301d6e4c4ae1f750385e759f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578bea2b65484e81ced453b0b1ad2d8cab385a3264c56cdcf062dc12e8cab2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58fc4d51978785b666cf205bbc877fc88bea7965c2dbc1dd98184507a78a61e"
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
