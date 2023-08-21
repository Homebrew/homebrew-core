class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.0.0.tar.xz"
  sha256 "bd6101d840036fb78e93a69df6cf3f9fd0c21cd754b695ff84a3b4add8ed0af7"
  license "MIT"
  revision 1
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa727208bc8516c1ceb20e97e22f1a50778c0d18a3af2e15ed3b02fdea802fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ca3ffeed48e550e054b884725b944384886f33e2ff2306f313fdebe6675abe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6c6b719a85143914667bd94fa1668bf686eec8b9a7108d27ea0799c4a128ff7"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2ec4fadd66ca1e3759085601a13b8cef5d711352531ed8fbe7d9bcf5542564"
    sha256 cellar: :any_skip_relocation, monterey:       "f414b4a3b42193367b565b90d039ea8e1c3676f25be558f0aef5d6efe4dfb9cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf94332c36c652b8b5e78ef62f11033dec8b12f2c1025df8ca4384fd1ff7752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a3b3e6b6e4379f21eb7ff18d8a49e9f601ceaaaa276dafbc4afb3fae715f8f"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
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
