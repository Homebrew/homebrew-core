class MacCleanupPy < Formula
  include Language::Python::Virtualenv

  desc "Python cleanup script for macOS"
  homepage "https://github.com/mac-cleanup/mac-cleanup-py"
  url "https://files.pythonhosted.org/packages/be/dc/75d83e78c24d7378dad5d3c0c20b68860c0b8e4d2875d242c5ea51f317eb/mac_cleanup-3.3.0.tar.gz"
  sha256 "6773f059ba2025d8121d0c764afe45d1d10d305df23f604b2a485e1360e526a3"
  license "Apache-2.0"
  head "https://github.com/mac-cleanup/mac-cleanup-py.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eec63de40a6249ab2595124edfe094dc03a4211226caabb93898c72cea9966c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4382ec8b1619469791c7f3aa35d7ecc7ab0b3e5a273f6f03b8c85652a5b598f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d3f47bc09461d1ce2c1055669e86b03b599be2676a5119c54d5572da86f9873"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e1e73ebd95814394446ea78b4b681ee72460070ae38a65c5da165aea81dc26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3cd0f446f075510ab4dd9e12333840ebfc085bd22e3b24a439fab163df4f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02577be91ae473eea3b27986d2d81e2cb9c3e85838e1d7c1c4512d1e6c1000fd"
  end

  depends_on "cffi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["cffi", "pycparser"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/04/96/43ed27f27127155f24f5cf85df0c27fd2ac2ab67d94cecc8f76933f91679/beartype-0.22.2.tar.gz"
    sha256 "ff3a7df26af8d15fa87f97934f0f6d41bbdadca971c410819104998dd26013d2"
  end

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/5e/3cada2f7514ee2a76bb8168c71f9b65d056840ebb711962e1ec08eeaa7b0/blessed-1.21.0.tar.gz"
    sha256 "ece8bbc4758ab9176452f4e3a719d70088eb5739798cd5582c9e05f2a28337ec"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/2a/92/734a4ab345914259cb6146fd36512608ea42be16195375c379046f33283d/editor-1.6.6.tar.gz"
    sha256 "bb6989e872638cd119db9a4fce284cd8e13c553886a1c044c6b8d8a160c871f8"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/c1/79/165579fdcd3c2439503732ae76394bf77f5542f3dd18135b60e808e4813c/inquirer-3.4.1.tar.gz"
    sha256 "60d169fddffe297e2f8ad54ab33698249ccfc3fc377dafb1e5cf01a0efb9cbe5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/dd/f8/8657b8cbb4ebeabfbdf991ac40eca8a1d1bd012011bd44ad1ed10f5cb494/readchar-4.2.1.tar.gz"
    sha256 "91ce3faf07688de14d800592951e5575e9c7a3213738ed01d394dcc949b79adb"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "runs" do
    url "https://files.pythonhosted.org/packages/26/6d/b9aace390f62db5d7d2c77eafce3d42774f27f1829d24fa9b6f598b3ef71/runs-1.2.2.tar.gz"
    sha256 "9dc1815e2895cfb3a48317b173b9f1eac9ba5549b36a847b5cc60c3bf82ecef1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/62/bf/8b98081f9f8fd56d67b9478ff1e0f8c337cde08bcb92f0d592f0a7958983/xattr-1.1.4.tar.gz"
    sha256 "b7b02ecb2270da5b7e7deaeea8f8b528c17368401c2b9d5f63e91f545b45d372"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/72/b2/e3edc608823348e628a919e1d7129e641997afadd946febdd704aecc5881/xmod-1.8.1.tar.gz"
    sha256 "38c76486b9d672c546d57d8035df0beb7f4a9b088bc3fb2de5431ae821444377"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    # Allow 3.14: https://github.com/mac-cleanup/mac-cleanup-py/pull/277
    inreplace "pyproject.toml", 'python = ">=3.10,<3.14"', 'python = ">=3.10"'
    virtualenv_install_with_resources
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    (testpath/"mac_cleanup_py/config.toml").write <<~TOML
      enabled = ["trash"]
    TOML

    assert_match version.to_s, shell_output("#{bin}/mac-cleanup -h")

    output = pipe_output("#{bin}/mac-cleanup --dry-run", "y", 0)
    assert_match "Dry run results", output
  end
end
