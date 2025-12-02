class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://github.com/linode/linode-cli"
  url "https://files.pythonhosted.org/packages/32/03/d5a093199a0b934bd90f6bcb1714572be344d2049793168650723af74b7b/linode_cli-5.64.0.tar.gz"
  sha256 "d91a5ec0d8cf291eeee8dd16ff0319185b58865f34a9f8f0d97b55c5715eb7c3"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbe0050a14e178fa442957027bef12233724baf0c6aa1307b4cc1c3b0231a49f"
    sha256 cellar: :any,                 arm64_sequoia: "f179337906cfed4a072609a679b8d91cf6878a32c9a38354b3eb7c0ce34676c5"
    sha256 cellar: :any,                 arm64_sonoma:  "cd84f9fc829e134dd53f4b66bafa236daf7f70ce985e3281d7a8e57c907598bc"
    sha256 cellar: :any,                 sonoma:        "c7203d6f0b0f175aed40b8f66fac272597b0095a7eaa548ba5d1bfffd389ba66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4bec6ffbc02b8573860539e4b7f40379b351cd5fc4ccbfebf234013c21acb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24898997131435d94d6daef36bbf0a417a1244590fdf99efb542a14cae25b60"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "linode-metadata" do
    url "https://files.pythonhosted.org/packages/72/30/0707067f33ca0af20ca96bcfbc7bf699faa9e6cfbccfc3e0d8d9bdd36b19/linode_metadata-0.3.2.tar.gz"
    sha256 "e7fb476303ff69c21dc825b5beefb32923f2c1ab475b0c5c50d6c2e7d4c87017"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi3" do
    url "https://files.pythonhosted.org/packages/94/0a/e7862c7870926ecb86d887923e36b7853480a2a97430162df1b972bd9d5b/openapi3-1.8.2.tar.gz"
    sha256 "a21a490573d89ca69ada7cbe585adb2fca4964257f6f3a1df531f12815455d2c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"linode-cli", "completion", shells: [:bash, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linode-cli --version")

    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("#{bin}/linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end
