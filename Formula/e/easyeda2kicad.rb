class Easyeda2kicad < Formula
  include Language::Python::Virtualenv

  desc "Converts electronic components from EasyEDA or LCSC to a KiCad library"
  homepage "https://github.com/uPesy/easyeda2kicad.py"
  url "https://files.pythonhosted.org/packages/f1/78/fde265892294c733590a9089f37cc8ea1478b9c632d76c0a11b8f20fe6f3/easyeda2kicad-0.8.0.tar.gz"
  sha256 "a781be6d1076f6e06886a4292373eb930c9921de4c709d6dd91bb6ea104f4a4b"
  license "AGPL-3.0-or-later"
  head "https://github.com/uPesy/easyeda2kicad.py.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63ed5e301650da8befc358c541925387a1f08b8eff7f0ce6a6c929a305961945"
    sha256 cellar: :any,                 arm64_sonoma:  "d0014b3a6121857ab6c8bd613f394d1c18d68ec6491b20bc60834a76109936ab"
    sha256 cellar: :any,                 arm64_ventura: "7d35b33026997cbc4fe5eab77ab2b052b22e586d8c9aaf2d886aea8d9d752c19"
    sha256 cellar: :any,                 sonoma:        "bcfd1712307952ae5734a3b388582968b872da58a1942e02998fa87b8b791518"
    sha256 cellar: :any,                 ventura:       "61ee7b4c3d3b2e8268b59b1dce11d1ed967a6a397b28198bd7a3cb3d404b12be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ef3d53d81f86f468ca0d65f125101c836b8eb40f8f15acb275a5ab3194092c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b4e8ded36b17d0d72029b1df3c1275aa92e428e232f0bdccb171ef12937b21"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/93/a3/698b87a4d4d303d7c5f62ea5fbf7a79cab236ccfbd0a17847b7f77f8163e/pydantic-2.11.1.tar.gz"
    sha256 "442557d2910e75c991c39f4b4ab18963d57b9b55122c8b2a9cd176d8c29ce968"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/b9/05/91ce14dfd5a3a99555fce436318cc0fd1f08c4daa32b3248ad63669ea8b4/pydantic_core-2.33.0.tar.gz"
    sha256 "40eb8af662ba409c3cbf4a8150ad32ae73514cd7cb1f1a2113af39763dd616b3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0e/3e/b00a62db91a83fff600de219b6ea9908e6918664899a2d85db222f4fbf19/typing_extensions-4.13.0.tar.gz"
    sha256 "0a4ac55a5820789d87e297727d229866c9650f6521b64206413c4fbada24d95b"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"easyeda2kicad", "--full", "--lcsc_id=C2040", "--output", testpath/"lib"
    assert_path_exists testpath/"lib.3dshapes"
    assert_path_exists testpath/"lib.kicad_sym"
    assert_path_exists testpath/"lib.pretty"
  end
end
