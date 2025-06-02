class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.2.4.tar.xz"
  sha256 "f82b419750fcce561f3f897a0486b180186845d76fb5d99f248ce166108189c7"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b253ab1acb1ccae1a0530bbeb7f101b335bb6fce1ed9813d01bbfa5d05e0413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c93fb307e80b60809d6209b0e16f20e009878964ea74f701dc7ece4666a3fa70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f3df4b38e174bfef1cc73029021bc1674f005dc0e54c2e2c648a0432d08dde7"
    sha256 cellar: :any_skip_relocation, sonoma:        "baa4eb7a7c6ec3bbcd9ae6da71c058f2e1435364548d299c476600323d287fe6"
    sha256 cellar: :any_skip_relocation, ventura:       "a3fccf2fcc860c5add56455604c071f49c29c374efbfc16c5c98220d046da4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8936a401e75c0a211f66e48f4159314e82251b542a60216d1c42dd99df695dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4083ac43fc55d0349ef42598ea47ab909cc11d13306a158c2c76aef8562b3d99"
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
