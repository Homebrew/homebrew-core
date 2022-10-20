class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.4.2.tar.gz"
  sha256 "0f728c7f49cc8ffb0c485547a114c94bdebd7eead9466b1b43f486ef583a3d73"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3cd1f15388555fd2bb5f4fd580f315e1bada283d4f4ce6aa2411bbfbd7c3b079"
    sha256 cellar: :any,                 arm64_big_sur:  "0fbf3f4908554abfcda3a7b49c8f49bc878152dcbaad4d4fa8c19cce9f6b2f6a"
    sha256 cellar: :any,                 monterey:       "145445f0a7f6267c1490fa94bec8dcf71abc693759bfd129059528e9347a0a12"
    sha256 cellar: :any,                 big_sur:        "5c52fe8dd74e83a4a7048ae8a4f42661c2738718ea40ebede07ecf83771ba5ff"
    sha256 cellar: :any,                 catalina:       "387724382d30ce0ac900da57f737d0f3ba91a57e29242e8b790f4ade97bf7179"
    sha256 cellar: :any,                 mojave:         "090af1343e6b5938c97127d0c7a63fe49804269c0dc0c98c19ed160798b34bec"
    sha256 cellar: :any,                 high_sierra:    "23beea483f50121bdf7b545e0345ec5d192ee362fcf3402f999905c3ebcd8188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1874dc73e61a21044a336683b346b1bb5f30ae2c3c795608e0926a7902747b"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
