class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.52.0.tar.xz"
  sha256 "3cd8fee86f69a949cb610fee8cd9264e6873d07fa58411f6060b3d62729ed7c5"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b39724ea3ef883d0aafda76ffd26f9ec27ae64ecae4daccf6f7ce9c7f315999"
    sha256 cellar: :any,                 arm64_sequoia: "a55ab975a0b860bfab4918ecabf48f03dd359a98a7bbe845d5c25c3ae15ab0fe"
    sha256 cellar: :any,                 arm64_sonoma:  "fcf5618101ead6069b386f510ff10261d7f9a6335b83ecf15f51e62744d2a7a3"
    sha256 cellar: :any,                 sonoma:        "694913e8fbe7c64b8a5be1fd783fe7d143c2e84797d49cddb49500074ba8ce14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e21eb606330bf93dae359f23e25f5d8b66af83ea41f5b16ca2de2806b1fda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8e8fd1d6de3ccc81f237443144a5973b5ddb7ae5f6b45cedfc26b452886cfa"
  end

  depends_on "pkgconf" => :build

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
