class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.53.0.tar.xz"
  sha256 "5818bd7d80b061bbbdfec8a433d609dc8818a05991f731ffc4a561e2ca18c653"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eed886c74cb45001e81877c24d505796fa38062037a577bcf41f83aee4ee9756"
    sha256 cellar: :any,                 arm64_sequoia: "e0c5a9c7835cc58d38ceb8f7ff459509f6034022d20adc3ce0dbef5024558611"
    sha256 cellar: :any,                 arm64_sonoma:  "6b788ce3a12b46ac47f0a64b4b784f16bd814a01f10d5183fd82b378ad7783b2"
    sha256 cellar: :any,                 sonoma:        "e47de0d5a84d18dfe49a2a7f8036691b99f314015dd4eade43b039cfa941b296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d7ecf11c0883ca061d1559e9af07e91fe680b14a10c2e9e41ab8b7780a0ce0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226b3dd8f8599b172a42b7ca335e3c38f65bed3c8828a0c3f6e30a203dff7817"
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
