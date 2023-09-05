class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://git.sakamoto.pl/laudom/haruhi-dl"
  url "https://files.pythonhosted.org/packages/24/f2/a2d22274cfa8f09c849495e8a5106cf72365091b58d55a45c2c91d9f79b9/haruhi_dl-2021.8.1.tar.gz"
  sha256 "069dc4a5f82f98861a291c7edd8bb1ca01eb74602dd36220343a75cb7bb617a8"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aa894f84c47706348027874c65d722f0262b0867d3d011053e0159db4c5a273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aa894f84c47706348027874c65d722f0262b0867d3d011053e0159db4c5a273"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aa894f84c47706348027874c65d722f0262b0867d3d011053e0159db4c5a273"
    sha256 cellar: :any_skip_relocation, ventura:        "d301396fe3c9c5c75d1b808d87a5aa9975300d69a67f7ad0334b24b99b4e38b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d301396fe3c9c5c75d1b808d87a5aa9975300d69a67f7ad0334b24b99b4e38b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d301396fe3c9c5c75d1b808d87a5aa9975300d69a67f7ad0334b24b99b4e38b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d08de7bd41cf3850110950b094166ec4da94703a9bf29529ab1bd78a72c13a0"
  end

  disable! date: "2023-01-31", because: :deprecated_upstream

  depends_on "python@3.11"

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
