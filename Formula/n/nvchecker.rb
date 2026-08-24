class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/be/43/e2b9699bb92a8125a24f2052152dfbfa4286285e6ea7aa7a47e8728ed72e/nvchecker-2.22.tar.gz"
  sha256 "7c5d04d55e3faffa2f7e7a81165a2f6b68786f4b185d4e1e2ec7af03a524e784"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c11cb82945e5a651356ab249ce922db62df8f21bc0cf91d71167b4431ae5e8ba"
    sha256 cellar: :any, arm64_sequoia: "41f85afef6f7c1626b81c2a1b0f88b0f544f2ae4d97880f31b325b0a807f99b7"
    sha256 cellar: :any, arm64_sonoma:  "fd9be51860c4202cf928233e2897917c9edabea918d9084ca6357362e361dd60"
    sha256 cellar: :any, sonoma:        "5168bd9fc3e6dcf4798da8d3ff54c2db0124a5f7d560747a3d6f47e2d290d920"
    sha256 cellar: :any, arm64_linux:   "86c5ede36c682b5450c98581e80a86bd65a4bb0a38a4ffb1f7c4a37b236fe0a8"
    sha256 cellar: :any, x86_64_linux:  "c9add6166c13b339afb00984bd1824ac9eda5fee1d57b0dd92a052e0920f331f"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b8/d7/e7bfbc86e9f99ff7807e24de7703f032e9c9ba80bb355cf26e0e9bc5a75e/platformdirs-4.11.3.tar.gz"
    sha256 "66a73d38a849810252df809a3d8bcbda8e26f6c189920e7535ad608a48dbb5ab"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/81/bc/705aa3bc36b99946a128d068e1afd4b6f3eebb36c6b97f551f3d2d740460/pycurl-7.47.0.tar.gz"
    sha256 "5e3cf357939da8d4ceefe3c7f305afcf9b47cba66cfd95e7768ca43b38445e14"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/10/d3/343e5bb989d6515b1646cf3d40135d73f3d5e45339bded401b56cdac24dd/tornado-6.5.8.tar.gz"
    sha256 "9452e1b208a8bd771e2cb1f2ff564985b9b214bdebbe622793e1799e0a6bd23f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
