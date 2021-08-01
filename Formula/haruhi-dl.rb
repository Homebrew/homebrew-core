class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/24/f2/a2d22274cfa8f09c849495e8a5106cf72365091b58d55a45c2c91d9f79b9/haruhi_dl-2021.8.1.tar.gz"
  sha256 "069dc4a5f82f98861a291c7edd8bb1ca01eb74602dd36220343a75cb7bb617a8"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ade1ccfd21d9177acb8e31fdb68b03f07b3b184fa90c97362574034776e54e1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb23dd6c8909a55b27c200bac5d08d2eee65a14bb378d6ee3e15565c3f287cfb"
    sha256 cellar: :any_skip_relocation, catalina:      "bb23dd6c8909a55b27c200bac5d08d2eee65a14bb378d6ee3e15565c3f287cfb"
    sha256 cellar: :any_skip_relocation, mojave:        "bb23dd6c8909a55b27c200bac5d08d2eee65a14bb378d6ee3e15565c3f287cfb"
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
