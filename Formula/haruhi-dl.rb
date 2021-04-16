class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/8e/65/6dd176ef1ceaff2dbe6c3205aea97355a23ac5dc26d57de3bd8af5a0206c/haruhi_dl-2021.4.1.tar.gz"
  sha256 "0854dc9c61ad3b639fb90f87545eb12a92fc3ce499eb5848f844ec37aa28d591"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74dc7e58a265c64127e4c7db0e3532c504c8b1d52a2bfd6296d419bafe6292d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "20540e0bbc073a1c3e2cc37f46e537cb2952ae3e1125f2229bff0bb82d82afa3"
    sha256 cellar: :any_skip_relocation, catalina:      "307d026e98537305bd6ea425582212d6dec8efc318b3a0bac281033d37e54bef"
    sha256 cellar: :any_skip_relocation, mojave:        "9c8795b77635086b45641e6590ae51f41c6aa8d9a496e8c2ecfa8a3bada0f640"
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
