class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://git.sakamoto.pl/laudom/haruhi-dl"
  url "https://files.pythonhosted.org/packages/24/f2/a2d22274cfa8f09c849495e8a5106cf72365091b58d55a45c2c91d9f79b9/haruhi_dl-2021.8.1.tar.gz"
  sha256 "069dc4a5f82f98861a291c7edd8bb1ca01eb74602dd36220343a75cb7bb617a8"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966c61dfcc9b8849d593007e07c3254a5e243093ef7b3b3d74f7f1e06be569b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966c61dfcc9b8849d593007e07c3254a5e243093ef7b3b3d74f7f1e06be569b6"
    sha256 cellar: :any_skip_relocation, monterey:       "127ff0efc125444133103fd03f0f8b51c2492b1cf9af89db62eb78db12fabc94"
    sha256 cellar: :any_skip_relocation, big_sur:        "127ff0efc125444133103fd03f0f8b51c2492b1cf9af89db62eb78db12fabc94"
    sha256 cellar: :any_skip_relocation, catalina:       "127ff0efc125444133103fd03f0f8b51c2492b1cf9af89db62eb78db12fabc94"
    sha256 cellar: :any_skip_relocation, mojave:         "127ff0efc125444133103fd03f0f8b51c2492b1cf9af89db62eb78db12fabc94"
  end

  depends_on "python@3.10"

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
