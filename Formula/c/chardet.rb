class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
  sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db732b50f0ce62bfc6f1fe0472ad5e406617d5586299629c2d17e98233916fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db732b50f0ce62bfc6f1fe0472ad5e406617d5586299629c2d17e98233916fc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db732b50f0ce62bfc6f1fe0472ad5e406617d5586299629c2d17e98233916fc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "db732b50f0ce62bfc6f1fe0472ad5e406617d5586299629c2d17e98233916fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "db732b50f0ce62bfc6f1fe0472ad5e406617d5586299629c2d17e98233916fc3"
    sha256 cellar: :any_skip_relocation, monterey:       "db732b50f0ce62bfc6f1fe0472ad5e406617d5586299629c2d17e98233916fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a2dd8cdfbe1e564ea6b433c966262ed3d470420c5f34951361aef20bbd0215"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence 0.7525", output
  end
end
