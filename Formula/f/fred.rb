class Fred < Formula
  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/b9/4d/5997ff747d69b8451a63b92182eb3df42a87a171e0a1c8acc2792bc8afc1/fred-py-api-1.1.2.tar.gz"
  sha256 "361886a97b8016e3010557e2c2e60f5656f2192f37eae05fa53867c6c3b0653c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ce275d5c843ce253177418aaa9702610c5cec42bb895e652a8f670738e08991"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee5b209458739a4c8176040ec0ebec0346e73c2924e50fe4bf118d4edc23ef4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081ebd21cd9131bb88eb50eedf99849edeea7a0442f826cfb333ae2e652ab2df"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac932e610b08e6a1f72ea4e2bb116da7a711b90277a4ff6925effd0d90e5250a"
    sha256 cellar: :any_skip_relocation, ventura:        "7bfc4a0be445af8cd8ba20ec00db25c88c3e33f5ccd100ac6c9bee12065249cb"
    sha256 cellar: :any_skip_relocation, monterey:       "f4cecc47c2b042828d757cbff6b1401014d19c3a0106b8210772780a4d4059aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a5d5c3bb146a8befb05cc261fa6b7d8417373fab670a861aeb59744db9f6d68"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end
