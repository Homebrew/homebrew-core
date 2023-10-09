class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/22/25/e42c9be788883c94ed3a2bbaf37c2351cfe0d82cdb96676a629ed3adedec/nvchecker-2.12.tar.gz"
  sha256 "4200ddf733448c52309f110c6fa916727a7400f444855afa8ffe7ff1e5b0b6c8"
  license "MIT"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05ed5fdffe2be04d95332861c119b3b7d9e9833b94c2082a0f5de6335805e5e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d060f8e0b16cb3793c59030b94183ab90a00f1bc45349544a5e29103a531768e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b98554001621cccd4aa11017797e6df0be2a0329a571f468796e9d05047f5af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a34cb5e2bc9c3cef323193f7539c6d47dcb8afce17aade04db0c2c215e9582c6"
    sha256 cellar: :any_skip_relocation, ventura:        "76ccf0a122b395be8bab2a0f270db9c54591d8653ff63a1cdf19d9d6c6739647"
    sha256 cellar: :any_skip_relocation, monterey:       "b42fe78a7822a22eedbee5763b8e228a09d9822a4672f4e7fdc4d5f08825856b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a272820b38e39cee19277bbb24c5339e294731ff8654c17601a7ee1f2920233"
  end

  depends_on "jq" => :test
  depends_on "python-packaging"
  depends_on "python-pycurl"
  depends_on "python@3.11"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
