class Fiona < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geographic data files"
  homepage "https://fiona.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/51/e0/71b63839cc609e1d62cea2fc9774aa605ece7ea78af823ff7a8f1c560e72/fiona-1.10.1.tar.gz"
  sha256 "b00ae357669460c6491caba29c2022ff0acfcbde86a95361ea8ff5cd14a86b68"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e185ec84243f3876b9155f6a808fc37185ebf4f43d070d484893043b0b4b8962"
    sha256 cellar: :any,                 arm64_sequoia: "eb67ec1899e4bd093194fecfe412d4075b4549b92d7c67bbdef61ec57958ab60"
    sha256 cellar: :any,                 arm64_sonoma:  "545745b1ed597d12e44e9c998e552490c4af4ed79421f1912e1c14e0bf516c93"
    sha256 cellar: :any,                 sonoma:        "f8d1d462b80b2a6d3fd6fcad56bb567726c26f9057685e629c6692951e373c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b758f1abc2fff5f32496f62aa1646d6c0a3aa6f6fccb016c014de8a02e37ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c680dd74cf3eaa431bf51c7bfd8ca70a61c93e9d236bb3bcb9fbca1fab06c1c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "gdal"
  depends_on "python@3.14"

  conflicts_with "fio", because: "both install `fio` binaries"

  pypi_packages exclude_packages: "certifi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "cligj" do
    url "https://files.pythonhosted.org/packages/ea/0d/837dbd5d8430fd0f01ed72c4cfb2f548180f4c68c635df84ce87956cff32/cligj-0.7.2.tar.gz"
    sha256 "a4bc13d623356b373c2c27c53dbd9c68cae5d526270bfa71f6c6fa69669c6b27"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fio", shell_parameter_format: :click)
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
