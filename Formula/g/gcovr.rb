class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/19/6d/2942ab8c693f2b9f97052d6a6de4c27323a3bd85af7d062dc5bd3a2a9604/gcovr-6.0.tar.gz"
  sha256 "8638d5f44def10e38e3166c8a33bef6643ec204687e0ac7d345ce41a98c5750b"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "482b954d85f2feeb72f7699c7f6b8e70d9cbbcc904bcdcaec9b276507da8a32b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38d423544896f5fffddd5e6514006461ef219c47979ef08ea60b8fa068c734d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46904919249f4e477db9336fd27db5a5b9a9b196a9abbdacfd4aaa7bd5413a3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bb194f19ae25d53cc0a701ddb84e3c9417b73271d385af4323fc449e64602fd"
    sha256 cellar: :any_skip_relocation, ventura:        "bf1d15c9c92373761a37a2d8ceb1fc363b329e7ded3ba755da0f323d6733492c"
    sha256 cellar: :any_skip_relocation, monterey:       "c45809d5f29dbb35fed915a894e483cf4de4f739bb75cade7431c3a12d7af654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541a7704b5fd30a5d311846d71c39a188278bba4be4fcb5455dc2bd953af0dd4"
  end

  depends_on "pygments"
  depends_on "python-lxml"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
