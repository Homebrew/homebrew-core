class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.0.tar.xz"
  sha256 "60a7c2251cc2e588d5cd87bae567260617c6de0c22dca9cdbfc4c7d2b8990b62"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fcf108b482d8f8bd341e6d2e7109ee101471e27df80c0e518b24e453cbc288a"
    sha256 cellar: :any,                 arm64_sequoia: "e0a6ab1fd669ee633767dd3317da6ec4f5772a8840905aef4fc3f776bc26faaa"
    sha256 cellar: :any,                 arm64_sonoma:  "e68447227619ea5a782a05255b2d9625f04d950e097f7aab8c15d45ae8b1df6e"
    sha256 cellar: :any,                 arm64_ventura: "171b2c262e64b401dbad3a4c1b6883895e39630d564d44176db0a1e3d9c2b8b9"
    sha256 cellar: :any,                 sonoma:        "7cb4d864c7c2126bd37dee96599f644fd9d7d79e10f73a7153a4cea112e29696"
    sha256 cellar: :any,                 ventura:       "01383968b805f7969218fdcb10770d6741e490d991a1270ce4065fad53566e30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a214cebf4c8d4d4be1ffe3553a7bd79c2378d5ed11295c8c49af7b6916ce08f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3972cfb76d09ba4c6e288cfbf566dc9a5f1f510f1f320288515dde09b24aca4"
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
