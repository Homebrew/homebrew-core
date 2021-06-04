class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://files.pythonhosted.org/packages/d5/3f/924b6b400a3f1fb32a5e080509b3f39590ecc73111033dcc397f1917e5a9/internetarchive-2.0.3.tar.gz"
  sha256 "2ce0ab89fea37e5b2311bc7d163955e84f73f6beeac3942e17e9d51ad7cc9ffa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "444c7b0950abc32a994677a26baea3552b38657cc8282850ed3af8400affe40d"
    sha256 cellar: :any_skip_relocation, big_sur:       "4795f5dbef8f8c5e8c07ec878dfe308273b4e346922b76ac128396921071cb56"
    sha256 cellar: :any_skip_relocation, catalina:      "ff92b8523de18c71521b8245a08d7eae83d33c0292536c3551d9571b40c9adf4"
    sha256 cellar: :any_skip_relocation, mojave:        "1b7333d8a28ae74c4d20cfa387fa524de5bb2e2b8928db61be9ac51c73dcc97f"
  end

  depends_on "python@3.9"

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/79/0c/d0eaa9380189a292121acab65199ac95b9209b45006ad8aa5266abd36943/backports.csv-1.0.7.tar.gz"
    sha256 "1277dfff73130b2e106bf3dd347adb3c5f6c4340882289d88f31240da92cbd6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/02/54/669207eb72e3d8ae8b38aa1f0703ee87a0e9f88f30d3c0a47bebdb6de242/contextlib2-0.6.0.post1.tar.gz"
    sha256 "01f490098c18b19d2bd5bb5dc445b2054d2fa97f09a4280ba2c5f3c394c8162e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/2b/91/42bc143289fd5f032ab1b01c5da32dc162ae808a585122f27ed5bf67268f/schema-0.7.4.tar.gz"
    sha256 "fbb6a52eb2d9facf292f233adcc6008cffd94343c63ccac9a1cb1f3e6de1db17"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/35/35/bd5af89c97ad5177ed234d9e79d01a984f8b5226b8ffc8b5d3c4fc8e157d/tqdm-4.60.0.tar.gz"
    sha256 "ebdebdb95e3477ceea267decfc0784859aa3df3e27e22d23b83e9b272bf157ae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/ia"
  end

  test do
    metadata = JSON.parse shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end
