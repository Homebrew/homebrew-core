class Jello < Formula
  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/8a/1d/25e13e337f0c5c8076a4fc42db02b726529b611a69d816b71f8d591cf0f5/jello-1.6.0.tar.gz"
  sha256 "f0a369b2bd0c1db6cb07abbfd014034c22158c160e3df2a9d55b258bc6fbfa42"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4d6cc31b387c1fe93a7e266b93cbe7002a979be86fd77246ef327fc27ce62ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8687e61fec44b37cca8f894edf432a61bf676acb502925f7c405be9d2747187f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2257946436ffa8b8fab31fb61fb6ffbe4bfdadee11c32634a80d4731d578fc25"
    sha256 cellar: :any_skip_relocation, sonoma:         "642c12413e765240b446eaae76901de1b8785d3f55b9e444f0ae9c42e9d01877"
    sha256 cellar: :any_skip_relocation, ventura:        "4509857e6e5ade5fab8e3b23920b5a264dad794aa4737e8c3570b448f3c12b82"
    sha256 cellar: :any_skip_relocation, monterey:       "8ee736ddd04e020fb79357515cea3496c4e13fcce30dec38192ece2cb626c946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28d2350fe1395afc202db3a84b58282fb6f4ba97917cc8908ee4d387c91eb5a"
  end

  depends_on "python-setuptools" => :build
  depends_on "pygments"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
