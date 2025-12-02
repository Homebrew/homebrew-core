class Fiona < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geographic data files"
  homepage "https://fiona.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/51/e0/71b63839cc609e1d62cea2fc9774aa605ece7ea78af823ff7a8f1c560e72/fiona-1.10.1.tar.gz"
  sha256 "b00ae357669460c6491caba29c2022ff0acfcbde86a95361ea8ff5cd14a86b68"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "737fe2990ad3620035fe100b135cffcebd8a07042400d8903522872d8e8c6a0a"
    sha256 cellar: :any,                 arm64_sequoia: "b2817a27b3b1c78a6b3b8664e2313474eb8dcda3cab5b35c7eaf24dcd3a1b1a6"
    sha256 cellar: :any,                 arm64_sonoma:  "156d2f6b9c5ceffb63a965f26133fd1674230dce1f5247bbc18390fad809b0f1"
    sha256 cellar: :any,                 sonoma:        "ef072bbb9b4b623fdd62f6c8d5878c1d2f8aac0c8d224c6ac4ed980560e87eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "073942e11dddaf13092ea2982af7340095598246e2769805cded7b2311dab49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208cafb4ce351b0a85243f58e590964a4fe1805355de7d897ca3dfed7a71121c"
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
