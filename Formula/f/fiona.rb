class Fiona < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geographic data files"
  homepage "https://fiona.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/51/e0/71b63839cc609e1d62cea2fc9774aa605ece7ea78af823ff7a8f1c560e72/fiona-1.10.1.tar.gz"
  sha256 "b00ae357669460c6491caba29c2022ff0acfcbde86a95361ea8ff5cd14a86b68"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4788e6cf99582a5fcf1e4abce4daf43ff504482a19193e84804aab2a55b252f9"
    sha256 cellar: :any,                 arm64_sonoma:  "2d4556ca589bb67a2926ab0795e7301014c40b554ac540d0f1179c20f47eb6c7"
    sha256 cellar: :any,                 arm64_ventura: "69bf18aeb4f2097080198331df624d1c0cb3cc513aaae674bc6b9a96f5ef7eb6"
    sha256 cellar: :any,                 sonoma:        "0503bf091d2469c634b4e9adcd1006694fd0bb8a94b4e6303f7174047e97f202"
    sha256 cellar: :any,                 ventura:       "0eb27e2fa495234f3a09126af55384b4fb98ce50cffac8274ea398dad91f3bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5036103d33a7dc454778a2957b8dd9eabf880835a6986dc2a09ac617de461c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9ecbc80ed54a93dc848950821fdb15a292b9589da5acc1250b33eb4bf1faa3"
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

    generate_completions_from_executable(bin/"fio", shells: [:fish, :zsh], shell_parameter_format: :click)
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
