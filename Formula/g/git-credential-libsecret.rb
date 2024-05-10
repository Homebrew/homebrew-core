class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.45.0.tar.xz"
  sha256 "0aac200bd06476e7df1ff026eb123c6827bc10fe69d2823b4bf2ebebe5953429"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3087f86b520dcde0443ca3977de8d8c914e955c154944127433e3f0f91a81458"
    sha256 cellar: :any,                 arm64_ventura:  "af0e40c074afeefb41b3200918a91ca7fc757d49575e44b488e3822950ba0e17"
    sha256 cellar: :any,                 arm64_monterey: "7fd70b59c48344c8d61148930790baa8a0177d5d8fb554fb291082737998b0d6"
    sha256 cellar: :any,                 sonoma:         "c05e7ef18c62dea320747ddb13bb82e8984313cab21fdc0e3b87aca30842b4c2"
    sha256 cellar: :any,                 ventura:        "c1d004ebe169160a4130716da6fa18cff5bbabe62ebd18a5e4f738aeadfade51"
    sha256 cellar: :any,                 monterey:       "6e1576c4c9727888361aaa72d4060343841091b849e19cf5b2dac091a8da9f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb816713ced4d82f1a1253a72d403de1fb80bc88e1e0d8c56bccfc47d2dffbad"
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
