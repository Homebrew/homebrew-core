class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.4.4.tar.xz"
  sha256 "6d73729def143f72fc2491ca937a9cab86d2a8243bd845a5d1403169ad20660e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20805260d0f0717fd9eae775c879d1527e8f793b8a7701b739628a7c26e91889"
    sha256 cellar: :any_skip_relocation, big_sur:       "91d277b8e9cc51f55a82e7b2e6abd48623d0ef8e5e82fcb46f72407f5aaf1de8"
    sha256 cellar: :any_skip_relocation, catalina:      "037d54470df4c702cfa6054c0fd731d437472fa4cc2e547e0a48b49b687d2227"
    sha256 cellar: :any_skip_relocation, mojave:        "4688d98b7f3819d9f3f994630f676c80873a7e8356bb858a0edf67d13b1bd7fd"
  end

  head do
    url "https://github.com/nim-lang/Nim.git", branch: "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  depends_on "help2man" => :build

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
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
