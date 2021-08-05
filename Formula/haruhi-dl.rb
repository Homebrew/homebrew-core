class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/24/f2/a2d22274cfa8f09c849495e8a5106cf72365091b58d55a45c2c91d9f79b9/haruhi_dl-2021.8.1.tar.gz"
  sha256 "069dc4a5f82f98861a291c7edd8bb1ca01eb74602dd36220343a75cb7bb617a8"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea81fa790015d19ff63a57e553ca9914399becb582c22aa0afb6c689849eb81b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a12ef4839c85aaa8a9a895555e4e784d52b18eb285c67ff22632218381f2417"
    sha256 cellar: :any_skip_relocation, catalina:      "8a12ef4839c85aaa8a9a895555e4e784d52b18eb285c67ff22632218381f2417"
    sha256 cellar: :any_skip_relocation, mojave:        "8a12ef4839c85aaa8a9a895555e4e784d52b18eb285c67ff22632218381f2417"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # History of homebrew-core (video)
    haruhi_output = shell_output("#{bin}/haruhi-dl --simulate https://www.youtube.com/watch?v=pOtd1cbOP7k")

    expected_output = <<~EOS
      [youtube] pOtd1cbOP7k: Downloading webpage
      [youtube] pOtd1cbOP7k: Downloading MPD manifest
    EOS

    assert_equal expected_output, haruhi_output
  end
end
