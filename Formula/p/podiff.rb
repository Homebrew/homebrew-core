class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "https://puszcza.gnu.org.ua/software/podiff/"
  url "https://download.gnu.org.ua/pub/release/podiff/podiff-1.4.tar.gz"
  sha256 "231531f3b0b17615a1f0ca9d712a3c196686df9f1a641688c74a2574af78b22a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.gnu.org.ua/pub/release/podiff/"
    regex(/href=.*?podiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "657c4211b999a913ed69c42f55bb522c35d27988a8ea6ab72eb165780a2238b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a2621d0ce49422987139fd852a650667b5a2985c8c216c318af66c144d6d8b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e7f705d124f8b240f16ab6edacd30c094275e5ebcb5814ba5e9bdf9ae7bfeba"
    sha256 cellar: :any_skip_relocation, ventura:        "96d7320bfcaf7ca38f215341e709c4236b75a29f467381a77352e343399cbfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "0c49d38d09ff613608a0aa1347e9fdd08d4a59056b74843e4a81cbd2d6f3e84d"
    sha256 cellar: :any_skip_relocation, big_sur:        "102324c4a33351f8ade8b7ca889945300a5dc36a7b1fb93460b0d26124bda63f"
    sha256 cellar: :any_skip_relocation, catalina:       "72109e409ad2097e8e6137b7cf7cc2464df145ff2e2c8db65504f0185f9c4ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b64d367ffe00d91903f42a1b643e1b467b219f773f8d34b722d1c88ddfcc30c"
  end

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats
    <<~EOS
      To use with git, add this to your .git/config or global git config file:

        [diff "podiff"]
        command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

      Then add the following line to the .gitattributes file in
      the directory with your PO files:

        *.po diff=podiff

      See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
