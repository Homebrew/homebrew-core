class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.54.0.tar.xz"
  sha256 "f689162364c10de79ef89aa8dbf48731eb057e34edbbd20aca510ce0154681a3"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60dda60ed23adbd2cef8010ae0d38691e639e2b0f05baee72464bfa4960954ab"
    sha256 cellar: :any,                 arm64_sequoia: "fa4a6ddd91c846890a75391fee75882b9045bb8394753683dffa3064603de05e"
    sha256 cellar: :any,                 arm64_sonoma:  "314221fc285e619d14f6a5198b563143f21b1c0c9978b449993903e88fdb79b1"
    sha256 cellar: :any,                 sonoma:        "ce042515f2c7d83297e8a94862438e7459c533800d0b352d689648e94faac998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c752d6dacb824652db503fe3a36861e3d58ff6791622d97c0661f34ee38a62e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c292305d48c6c1ec599c3421ed7a4379b6b508679df5e1b82df1e2409213218"
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
