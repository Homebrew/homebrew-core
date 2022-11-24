class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.10.tar.xz"
  sha256 "13d7702f8b57087babe8cd051c13bc56a3171418ba867b49c6bbd09b29d24fea"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "045fb4b6a185a2777faa36ce9a833f4c22ebc8fb34355aff6109e5895e7e3abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43cd24e520f8e6058eb8a74fc9e32ddc0e63a63b44e3e4066bac9cba1ed4ab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e65de919d23c6e3beecbe8def4fdbc895eec6905c2bcfd404e27f97d173ea0ad"
    sha256 cellar: :any_skip_relocation, ventura:        "90f0c34be299fed5f3c8027ae27c389e1dec70c0616e9d00e79f4262249e2134"
    sha256 cellar: :any_skip_relocation, monterey:       "77176b57b17ae53e35138a5bc91be98df78f8e7415157f7e89d486816a8d1f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "709143fff4265d8d95bcd1eeb67a1e5c50b24525e60f1fc0d90c0442db682db2"
    sha256 cellar: :any_skip_relocation, catalina:       "4f5fc57392c8d04b3d23f19350e6db640689b0ea4ee6caf0646062ef9ca9569d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c133e78268012e5e8295dde39e4861be7f3a84b84f86443dad3d5f34986327ed"
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
