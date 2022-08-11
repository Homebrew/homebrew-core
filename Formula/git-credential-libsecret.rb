class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.2.tar.xz"
  sha256 "1c3d9c821c4538e7a6dac30a4af8bd8dcfe4f651f95474c526b52f83406db003"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "908aacc0184b568b10564bab0431ef8689800c0f025fe9f40e94f06dde27a0a6"
    sha256 cellar: :any,                 arm64_big_sur:  "9911d13935c8ce88f791d19a1abdcb78ee0c96b9fad3e404d04de802a295d101"
    sha256 cellar: :any,                 monterey:       "aee1eb37c52de6edf0f3aad20eddd08aa796ec446c02570b11415cba88cb65ee"
    sha256 cellar: :any,                 big_sur:        "b4471b51db4a0a931de4c6911d905704f6205dd0e781574ba6007629ba146af6"
    sha256 cellar: :any,                 catalina:       "6c1755103428b74eb51bb3b4330e3e35f44e4d8159a1179005fa0c53ef9dac3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eac1f15059a8671216d4ab2436f05cd5d02a9d5694a7db9480edec37c5d37e5"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
