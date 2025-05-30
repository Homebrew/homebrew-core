class Asitop < Formula
  include Language::Python::Virtualenv

  desc "Perf monitoring CLI tool for Apple Silicon"
  homepage "https://tlkh.github.io/asitop/"
  url "https://files.pythonhosted.org/packages/93/bc/8755d818efc33dd758322086a23f08bee5e1f7769c339a8be5c142adbbbc/asitop-0.0.24.tar.gz"
  sha256 "5df7b59304572a948f71cf94b87adc613869a8a87a933595b1b3e26bf42c3e37"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c1e7fc9030b7f6c0d68368093a95b6eb04a5aea4da0cf482ff7fd0929907dad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e47b9f4b8cddd211162e0c6f6f3df826c24af7c5af20fac83e4cbda1a00495"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7aa18d47f90cffa03a4854dc5317182544dbe09b4e0bead5134a53a8593488d"
  end

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.13"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "dashing" do
    url "https://files.pythonhosted.org/packages/bd/01/1c966934ab5ebe5a8fa3012c5de32bfa86916dba0428bdc6cdfe9489f768/dashing-0.1.0.tar.gz"
    sha256 "2514608e0f29a775dbd1b1111561219ce83d53cfa4baa2fe4101fab84fd56f1b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
    bin.env_script_all_files(libexec, PYTHONDONTWRITEBYTECODE: "1")
  end

  test do
    output = shell_output("#{bin}/asitop 2>&1", 1)
    # needs sudo permission to run
    assert_match "You are recommended to run ASITOP with `sudo asitop`", output
    assert_match "Performance monitoring CLI tool", shell_output("#{bin}/asitop --help")
  end
end
