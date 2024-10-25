class Doas < Formula
  desc "Execute commands as another user"
  homepage "https://github.com/slicer69/doas"
  url "https://github.com/slicer69/doas/archive/refs/tags/6.3p12.tar.gz"
  version "6.3p12"
  sha256 "e4f37745345c12d4e0c8c03c8237791729cf047dbd7b2455f8de60e2f82ac1b0"
  license "BSD-2-Clause"
  head "https://github.com/slicer69/doas.git", branch: "master"

  bottle do
    root_url "https://github.com/Neved4/homebrew-tap/releases/download/doas-6.3p12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3973d3f674d9de9fe6402e108064524105f82af8cf464ba97f22cb1a73742a03"
    sha256 cellar: :any_skip_relocation, ventura:      "2addf400597918085b22645fb17d45c9cd420298a9cdb60a41540d7d6c4c6eb8"
    sha256 cellar: :any_skip_relocation, monterey:     "a922ab3545bb5714dc994b77a4e81e6653422f34de7072cce2d78203cbd99c34"
  end

  depends_on :macos

  def install
    system "make", "all"
    bin.install "doas"
    bin.install "doasedit"
    bin.install "vidoas"
    man1.install "doas.1"
    man5.install "doas.conf.5"
    man8.install "doasedit.8"
    man8.install "vidoas.8"
  end

  def caveats
    <<~EOS
      To complete the installation, run the following command manually:
        sudo cp /etc/pam.d/sudo /etc/pam.d/doas
    EOS
  end
end
