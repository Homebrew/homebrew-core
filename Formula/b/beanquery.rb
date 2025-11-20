class Beanquery < Formula
  include Language::Python::Virtualenv

  desc "Customizable lightweight SQL query tool"
  homepage "https://github.com/beancount/beanquery"
  url "https://files.pythonhosted.org/packages/7c/90/801eec23a07072dcf8df061cb6f27be6045e08c12a90b287e872ce0a12d3/beanquery-0.2.0.tar.gz"
  sha256 "2d72b50a39003435c7fed183666572b8ea878b9860499d0f196b38469384cd2c"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bb8cb26caaf57d39d5de56dbb43c338af325b866018ad3f5b7f58fee470839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f37c3deaee2b019a12ca31efacb072b4338c9772fcaf0da585b361d37be81d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff682ffc3b90f6397ef978057db4a63d4629cf1e4e01200ad848a6eccf32695"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e612ab070eb3db9a1a363c39d7a836e3ea7a465270738ac31ddceae70d92517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd9d89c48614beec712adb1d8e77983fb9cc5e962beb4e0a0424b2833c94b614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4b4f40ee6c97f10bf46b1d9b2d6da0ca2bf0566986144cda7f47e4cbac177a9"
  end

  depends_on "bison" => :build # for beancount
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14"

  uses_from_macos "flex" => :build # for beancount

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/93/a6/973010277d08f95ba3c6f4685010fe00c6858a136ed357c7e797a0ccbc04/beancount-3.1.0.tar.gz"
    sha256 "1e70aba21fae648bc069452999d62c94c91edd7567f41697395c951be791ee0b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tatsu-lts" do
    url "https://files.pythonhosted.org/packages/4a/40/4bbdba35865ebaf33a192cea87bfafb4f4ca6b4bf45c18b89c6eed086b98/tatsu_lts-5.13.1.tar.gz"
    sha256 "b9f0d38bf820d92077b5722bad26f68020c8e4ee663f7e35d4a0d95e4ebc5623"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.beancount").write <<~EOS
      option "title" "Beanquery Test"
      2025-01-01 open Assets:Cash
      2025-01-02 * "Test Transaction"
        Assets:Cash          -10.00 USD
        Expenses:Test        10.00 USD
    EOS

    output = shell_output("#{bin}/bean-query test.beancount 'select account, sum(position)' --no-errors")

    assert_match "Assets:Cash", output
    assert_match "Expenses:Test", output
  end
end
