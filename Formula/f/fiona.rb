class Fiona < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geographic data files"
  homepage "https://fiona.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/51/e0/71b63839cc609e1d62cea2fc9774aa605ece7ea78af823ff7a8f1c560e72/fiona-1.10.1.tar.gz"
  sha256 "b00ae357669460c6491caba29c2022ff0acfcbde86a95361ea8ff5cd14a86b68"
  license "BSD-3-Clause"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b3894082992e0f3ce486e2688c5b7d63bdb39ec9b45983f6fc41d08ec992f0c4"
    sha256 cellar: :any, arm64_tahoe:       "4f257790d661ab260a8f06bc666f284f713a72b3d628b0479d181d9c545d7556"
    sha256 cellar: :any, arm64_sequoia:     "981393e7eb02958c6eb5e44d2b03c88fe374f49c77ef12d32c11de792bfb02a6"
    sha256 cellar: :any, arm64_linux:       "baa93e7988e5cdc9d8198d33d48f285e1d0bfbfbe324b0fa3dd32bb178068eae"
    sha256 cellar: :any, x86_64_linux:      "3edb10941f264528f3ed14ad0ee6261d91e64e63a4f971828988182b8105bda9"
  end

  depends_on "certifi" => :no_linkage
  depends_on "gdal"
  depends_on "python@3.15"

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

  resource "test_file", :test do
    url "https://github.com/Toblerity/Fiona/raw/refs/heads/main/tests/data/coutwildrnp.shp"
    sha256 "fc9f563b2b0f52ec82a921137f47e90fdca307cc3a463563387217b9f91d229b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fio", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fio --version")

    ENV["SHAPE_RESTORE_SHX"] = "YES"

    testpath.install resource("test_file")
    output = shell_output("#{bin}/fio info #{testpath}/coutwildrnp.shp")
    assert_equal "ESRI Shapefile", JSON.parse(output)["driver"]
    assert_equal "Polygon", JSON.parse(output)["schema"]["geometry"]
  end
end
