class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/e8/1a/20e9924eed819d8d1d0a127708681e100fa0323c0c1ae25f73869a5aa540/haruhi_dl-2021.6.1.tar.gz"
  sha256 "c423d5be4807224eb12e3fe8cad7dd9ff014d2f95615f4e6ad8cf7cbb669bf55"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc3aa6938b942b48f5449ee5d1b6ae8cf25912ad4f7647f22e2b61296c339fc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe067db3e867b03e593b8fee77276216e0db7ad79f3001115e1d8e1d95d213d0"
    sha256 cellar: :any_skip_relocation, catalina:      "fe067db3e867b03e593b8fee77276216e0db7ad79f3001115e1d8e1d95d213d0"
    sha256 cellar: :any_skip_relocation, mojave:        "fe067db3e867b03e593b8fee77276216e0db7ad79f3001115e1d8e1d95d213d0"
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
