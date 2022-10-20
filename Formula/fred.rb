class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/1e/7a/bb49f22f2ce33109ce5a5f8c7b85263cbc97bf9c9b44ba612c8380d3406f/fred-py-api-1.1.0.tar.gz"
  sha256 "f1eddf12fac2f26f656e317a11f61ec0129ba353187b659c20d05a600dba78c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc6e0ad74f29f56612611c3d9ee28f1d7903f8cc230d18100f52fac35cbeb2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b38b4ff1dc1f3ff4b0674ce949463bd14814817364a54c107c3344a5389a84a3"
    sha256 cellar: :any_skip_relocation, monterey:       "2571bea5f0c8627ad5412e71df35701f20bc570140e2b9e3c0e7e3599dde2d45"
    sha256 cellar: :any_skip_relocation, big_sur:        "60fabae8d4296af852d40f877f2771ed90b3fde6a4be7c0778c6f0f8a973f510"
    sha256 cellar: :any_skip_relocation, catalina:       "fd910a7aaf68018c1c14e19e5893cf1784143e381ce99adf2e281aa14625dace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e1180d8a7bd43ffcdf87d36613a7d7dd5b0704eacb88ac16e243314e5bbe218"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    assert_match \
      shell_output("#{bin}/fred --api-key sqwer1234asdfasdfqwer1234asdfsdf categories get-category -i 15", 2), \
      "Bad Request.  The value for variable api_key is not registered."
  end
end
