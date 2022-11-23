class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.4.2.tar.gz"
  sha256 "0f728c7f49cc8ffb0c485547a114c94bdebd7eead9466b1b43f486ef583a3d73"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b947a3ef610d4099bb69f3ce13a4dd1ab5cc3cf54ff26bad1a0416ec17db6345"
    sha256 cellar: :any,                 arm64_monterey: "bf3d14d3e49b2706d08eda7eb2c9996dd1dd084620750657b64ca4eaaed1ffbc"
    sha256 cellar: :any,                 arm64_big_sur:  "e533b21966078b880931e146e2de12983de87ad946a697b4123d2c8f53bd884a"
    sha256 cellar: :any,                 ventura:        "25119e705899f67ed5e6ad09cdb548380e7223b67f234c82b70507ee0db2e95f"
    sha256 cellar: :any,                 monterey:       "74c5d18624b71730015cab7a8a56024dc938d22b15c99cda2e00bef8385def6e"
    sha256 cellar: :any,                 big_sur:        "48ca1fc5e4ce96b10f13cddf5e1fe5222a7419133b348c7e563ab2ae51f4c6af"
    sha256 cellar: :any,                 catalina:       "dd1226f0b393f6ea83d826b0c4c893caba223a466d13812cda14602d3e796f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "916cc109ec67bcc75376c39c8ce9503854d532c8f5d341770ed7b70efda06cc5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Patch for OpenSSL 3 compatibility
  # Upstream PR ref, https://github.com/foriequal0/git-trim/pull/195
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a67e684/git-trim/openssl-3.diff"
    sha256 "b54a6ae417e520aefa402155acda892c40c23183a325cf37ac70920b5ad0246c"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
