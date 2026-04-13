class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https://github.com/cloudflare/python-cloudflare-cli4"
  url "https://files.pythonhosted.org/packages/77/fd/87b3e026dcee2a6b891f2b6c98b8f0bc98a175c4b731c046b528298c07c5/cloudflare_cli4-2.19.4.post3.tar.gz"
  sha256 "36efe09d188678e8c99e654b79162758594107342d11f88192423aa47fd6c0b8"
  license "MIT"
  revision 3
  head "https://github.com/cloudflare/python-cloudflare-cli4.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50ba9abb0b3335aaa5dc9dbe8760a714621f9acbf097e0cd77dd986ac3af4fea"
    sha256 cellar: :any,                 arm64_sequoia: "b2978a27a34ea052c89aace4befd96837e8f237d1a8abfadcc8677f018a1dadc"
    sha256 cellar: :any,                 arm64_sonoma:  "48bf8b68decbadfbf970c6d2fe916bf6ed67b1eecb3253357e662758e2f52e9d"
    sha256 cellar: :any,                 sonoma:        "3f97c7252b537789b295aebe1bf69f7d2bb240d225aba1301fe4bf4e094e339e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f30ea74570fbea3f7ccb754d20c4feb05dea930c41947ab24b638d477c759246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "172349783f328752daac78327d7782214aec5a43999a14a16757b97c8f6d26d4"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".cloudflare/cloudflare.cfg").write <<~EOS
      [CloudFlare]
      email = BrewTestBot@example.com
      token = 00000000000000000000000000000000
      [Work]
      token = 00000000000000000000000000000000
    EOS

    output = shell_output("#{bin}/cli4 --profile Work /zones 2>&1", 1)
    assert_match "cli4: /zones - 6111 Invalid format for Authorization header", output
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/cli4 --version 2>&1", 1)
  end
end
