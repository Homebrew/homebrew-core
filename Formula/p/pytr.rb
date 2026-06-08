class Pytr < Formula
  include Language::Python::Virtualenv

  desc "Use TradeRepublic in terminal and mass download all documents"
  homepage "https://github.com/pytr-org/pytr"
  url "https://files.pythonhosted.org/packages/11/91/6296f202e588f830437d27d0876745eca4e21555d9a11a504ac8270f1e4e/pytr-0.4.9.tar.gz"
  sha256 "cd9a9547ba8de75caf9322bb205e71871890a57a69512a6e48a72bb354866332"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "071227d7c5f44ea716bbd7ec8c99c36fd6c83c7b7d09d8a462cef79511feda8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c1478c63171b89c9f17677d1747281874f64cd101e3d75263632f2a0b134c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a49070efaf26303f77d52e5bac79dfbed911a94921a7b85d891c1551dbe72e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7331a1acc0ed754343f0301637952b8aabc3877e4abf1c78b3a449455f2589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01bf623fc03e2ad9d459d32d95e385251d78f4b9fcde59eb1f379f4ae5c40ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4c9f629a2a59356231ef495bc72bd6a13bf3df50e827e083c95043d722b16df"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "node"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography playwright],
                extra_packages:   %w[greenlet pyee typing-extensions]

  # No sdist on PyPI, so we use the GitHub tarball
  # Ref: https://github.com/microsoft/playwright-python/issues/2579
  resource "playwright" do
    url "https://github.com/microsoft/playwright-python/archive/refs/tags/v1.58.0.tar.gz"
    sha256 "27ce34440c0a73d8123f721f8288689db57a40358e40f1ab234c936f4a2c08eb"

    livecheck do
      url :url
    end
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/48/5b/89fcfebd3e5e85134147ac99e9f2b2271165fd4d71984fc65da5f17819b7/curl_cffi-0.15.0.tar.gz"
    sha256 "ea0c67652bf6893d34ee0f82c944f37e488f6147e9421bef1771cc6545b02ded"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3c/3f/dbf99fb14bfeb88c28f16729215478c0e265cacd6dc22270c8f31bb6892f/greenlet-3.5.0.tar.gz"
    sha256 "d419647372241bc68e957bf38d5c1f98852155e4146bd1e4121adea81f4f01e4"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/8b/04/e7c1fe4dc78a6fdbfd6c337b1c3732ff543b8a397683ab38378447baa331/pyee-13.0.1.tar.gz"
    sha256 "0b931f7c14535667ed4c7e0d531716368715e860b988770fc7eb8578d1f67fc8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/88/f8/175b823241536ba09da033850d66194c372c65c38804847ac9cef0239542/requests_futures-1.0.2.tar.gz"
    sha256 "6b7eb57940336e800faebc3dab506360edec9478f7b22dc570858ad3aa7458da"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/b0/7a/7f131b6082d8b592c32e4312d0a6da3d0b28b8f0d305ddd93e49c9d89929/shtab-1.8.0.tar.gz"
    sha256 "75f16d42178882b7f7126a0c2cb3c848daed2f4f5a276dd1ded75921cc4d073a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    venv = virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pytr", "completion", shells: [:bash, :zsh])

    # Help find playwright when installed inside virtualenv
    rm(bin/name)
    (bin/name).write_env_script libexec/"bin"/name, PATH: "#{libexec}/bin:${PATH}"

    # Replace bundled node
    bundled_node = venv.site_packages/"playwright/driver/node"
    rm(bundled_node)
    ln_sf (Formula["node"].opt_bin/"node").relative_path_from(bundled_node.dirname), bundled_node
  end

  test do
    output = shell_output(
      "#{bin}/pytr --debug-logfile pytr.log login -n +4912345678 -p 1234 2>&1", 1
    )
    assert_match "Retrieving AWS WAF token using Playwright", output
    assert_path_exists testpath/"pytr.log"
    assert_match "Looks like Playwright was just installed or updated", (testpath/"pytr.log").read
  end
end
