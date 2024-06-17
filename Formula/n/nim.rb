class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.0.4.tar.xz"
  sha256 "71526bd07439dc8e378fa1a6eb407eda1298f1f3d4df4476dca0e3ca3cbe3f09"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08901a7f566f0513521a5814f87a11d593df7a471914ef34625cedb44644cf45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b69ee0671acbc72ee02de1c82c5c9129fd1f9a55467621f2c32620056032ecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3fab6eeed221fcf97c6416139c831390d9becd77d09074b2a343c87ea16fed6"
    sha256 cellar: :any_skip_relocation, sonoma:         "674f0162136814d1555eac5699ecd977bdc494217401d4d6f90dd8719a5e1afe"
    sha256 cellar: :any_skip_relocation, ventura:        "3a074c2dcee6e3e0e53569eda343be5ee16d22b43ba24f5227fe8d7bdda633d2"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef96b141be5a1d3b3e5decc17ce38812812f814d2b1f5e5a5417587742c36c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b46ce433d100c39380459700770fc23675bc46b36157330a3810177a62c85e8"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "mongodb-atlas-cli", because: "both install `atlas` executable"

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
