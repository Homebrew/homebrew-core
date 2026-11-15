class MacCleanupPy < Formula
  include Language::Python::Virtualenv

  desc "Python cleanup script for macOS"
  homepage "https://github.com/mac-cleanup/mac-cleanup-py"
  url "https://files.pythonhosted.org/packages/b5/62/dcc23b0a85ddf7810261edd6f92d1727a00cfab83064b2bf591866cdc846/mac_cleanup-3.4.0.tar.gz"
  sha256 "47718062d255f83eb47e108401e99ceb87e9d6a4d9423008739d74dc1b3aafa2"
  license "Apache-2.0"
  head "https://github.com/mac-cleanup/mac-cleanup-py.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "182e1e360f28cdfb01b36226c254e06f2dc445eb04e4ea36710b984841fdb1ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c73433bdc35eaa57fc42067e98680bf2733b55b71450ecb8e15129c254614eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbd980f1ed9cc8838ffbd36dbe81fe3f2d2586f069b70d56f904a64560919e05"
    sha256 cellar: :any,                 arm64_linux:       "30eef582c998495df16e9d69ff6ab2454418ce9568791f8849430e63c455084d"
    sha256 cellar: :any,                 x86_64_linux:      "f79b5678365ca0cb6e21824ab14294845595b0df597baff6fc8b66964bb7436c"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "cffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/79/34/c0cfdaee9c796c8381439fed0fcab62810753b8b0adb1ec88fa7f41eaa5d/beartype-0.23.1.tar.gz"
    sha256 "8b805f246b32931c74f2b321ea0939fe5bb2ff43c12a3eff19cc4c854b832e1d"
  end

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/8f/e3/53462b28d7a06f2fcf820863f951255f4e022e4988981b0a5ca339f7773b/blessed-1.52.0.tar.gz"
    sha256 "a6f42b2875c7afee78420ac9919699d5c3dce35bfa9ad45bc158b1713fc33d0d"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/c3/10/d3ace6204a16ad24d9c5e330b6b09e020967d3dda3b5a6c34caa182be7b7/editor-2.0.1.tar.gz"
    sha256 "6ecdff42bf4a32ba250f42676dbcdd75ce5fa498ca8dd1e1918c63a2518538cf"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/c1/79/165579fdcd3c2439503732ae76394bf77f5542f3dd18135b60e808e4813c/inquirer-3.4.1.tar.gz"
    sha256 "60d169fddffe297e2f8ad54ab33698249ccfc3fc377dafb1e5cf01a0efb9cbe5"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/39/d7/6e6d474ec5eaeca6a61acc17766bb19563b3a372b4b9d92910078f5fe49f/jinxed-2.1.0.tar.gz"
    sha256 "7e755b831faa2443d44fb4ce7c0202eb9c3ed39bd5bf1193365888f4f6092b54"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "runs" do
    url "https://files.pythonhosted.org/packages/f2/ae/095cb626504733e288a81f871f86b10530b787d77c50193c170daaca0df1/runs-1.3.0.tar.gz"
    sha256 "cca304b631dbefec598c7bfbcfb50d6feace6d3a968734b67fd42d3c728f5a05"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/08/d5/25f7b19af3a2cb4000cac4f9e5525a40bec79f4f5d0ac9b517c0544586a0/xattr-1.3.0.tar.gz"
    sha256 "30439fabd7de0787b27e9a6e1d569c5959854cb322f64ce7380fedbfa5035036"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/7a/3b/5a0d2670bab661164e27a5c27c448ae6204458c97cb94ccf89d0c47715bc/xmod-1.10.0.tar.gz"
    sha256 "b40b2a54d56684b01eb9627892b0c179918e8ef0bd4d7f3bac7a3fdba11cd6e6"
  end

  def install
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
