class Fiona < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geographic data files"
  homepage "https://fiona.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/51/e0/71b63839cc609e1d62cea2fc9774aa605ece7ea78af823ff7a8f1c560e72/fiona-1.10.1.tar.gz"
  sha256 "b00ae357669460c6491caba29c2022ff0acfcbde86a95361ea8ff5cd14a86b68"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "00b95ac4bf7772eb38a49123a2bda485fabb21c0e1c92ba49fb4630ddf9f0a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "00eadb2d61339a282cff600a0b0914decfc4ae1cb53ac1d4546b40528811147c"
    sha256 cellar: :any,                 arm64_ventura: "3887127436fd935145d865af7549a050e7ad7b1b307ea295b412060beef310f7"
    sha256 cellar: :any,                 sonoma:        "2a2cf6a51c01bc67a4bc2e661d0e0c2e0ffe0b09bb8b661e4071d6dab6d613a6"
    sha256 cellar: :any,                 ventura:       "f13fc2f8c11c0f918f2761725e7483cdd91948d21041fa51c15a73bb3182bf13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a306357c631c92a7f61e46b0211ea0d910a6883e849edc8c400e0bb122a804d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16820e10169e49e3787ff5c4507ce74a9fd95188d045fdd0173e00f4a08e9880"
  end

  depends_on "certifi"
  depends_on "gdal"
  depends_on "python@3.13"

  conflicts_with "fio", because: "both install `fio` binaries"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "cligj" do
    url "https://files.pythonhosted.org/packages/ea/0d/837dbd5d8430fd0f01ed72c4cfb2f548180f4c68c635df84ce87956cff32/cligj-0.7.2.tar.gz"
    sha256 "a4bc13d623356b373c2c27c53dbd9c68cae5d526270bfa71f6c6fa69669c6b27"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fio", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fio --version")

    ENV["SHAPE_RESTORE_SHX"] = "YES"

    resource "test_file" do
      url "https://github.com/Toblerity/Fiona/raw/refs/heads/main/tests/data/coutwildrnp.shp"
      sha256 "fc9f563b2b0f52ec82a921137f47e90fdca307cc3a463563387217b9f91d229b"
    end

    testpath.install resource("test_file")
    output = shell_output("#{bin}/fio info #{testpath}/coutwildrnp.shp")
    assert_equal "ESRI Shapefile", JSON.parse(output)["driver"]
    assert_equal "Polygon", JSON.parse(output)["schema"]["geometry"]
  end
end
