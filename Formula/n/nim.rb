class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.2.0.tar.xz"
  sha256 "ce9842849c9760e487ecdd1cdadf7c0f2844cafae605401c7c72ae257644893c"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc74fb77b48f05f8feefd2e643359efadeeaa4eec0a2d94882564aee1563e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae2f159bb433847dc9e26b1ef7b0f9b31afa9f095c88bb54b899fa265b6fa95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "008118534506dcc73df8daca97ee8437bdbe74cc9201055fe6565c6b26bfe9e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a4e5222e2aaf6708da811abc90381923c8c4fcf843fd5d7ab84225f591a1c8"
    sha256 cellar: :any_skip_relocation, ventura:       "e85c4c1bda5a6a82059f7fa562e4ed875793c4f2122e6cf9f707bd7d7cffef47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb0465231f57d4156acc2fef0671a1fdfb86735e38063ad2e02d98a6d1d7a93"
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
