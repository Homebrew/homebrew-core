class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.47.1.tar.xz"
  sha256 "f3d8f9bb23ae392374e91cd9d395970dabc5b9c5ee72f39884613cd84a6ed310"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2fa424bd78b2ed41760cdc93504630720ee4ce9f007cd0f846917f84cd3bc47d"
    sha256 cellar: :any,                 arm64_sonoma:  "6f9b6e461fd8cfacb7d4ea22c074f1fc1f6bf1f8d61e29a7ea3a0d5adeba89a4"
    sha256 cellar: :any,                 arm64_ventura: "b028d6b68639b514997dca464ad1c88f8e7e4592dbedf0b82d70e6e07bb79579"
    sha256 cellar: :any,                 sonoma:        "141a713330943dd81c540ca77fb854832672b8c3bfd173cf05d21ed9f0d47aa7"
    sha256 cellar: :any,                 ventura:       "5f46cbb938ca94694b76c2a5ed4472125b960e368a7c6d77a2898678ae138815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3307d6056663fa544c169d5d00c26741340859842dda70dece03ab1f5b95999"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libsecret"

  on_macos do
    depends_on "gettext"
  end

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
