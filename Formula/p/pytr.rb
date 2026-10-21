class Pytr < Formula
  include Language::Python::Virtualenv

  desc "Use TradeRepublic in terminal and mass download all documents"
  homepage "https://github.com/pytr-org/pytr"
  url "https://files.pythonhosted.org/packages/05/ac/c3d75b9337f81bb3a54fa61d54d44ad4672812a6613cfb4649e221f57132/pytr-0.4.10.tar.gz"
  sha256 "41dbb9446d290fc36b21410b5547504088e7fdf49a6e637675c900ec353381d5"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a8a86c8613d923b6b8e7ae8e217dd5fa1ef073fb0e0a7ed829f7d818adf72a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "521b3f2fc0edcf6124a99f5b7739b63043b3376e6e1aa3c5228129fee6eb1926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbb821d3fdbe391956d3d1a9d23adc4e45c2bc30a0eaea1e9c3aa14e10eb458d"
    sha256 cellar: :any,                 arm64_linux:       "4e56954c66a25ecda0b765a48cfdbd2190313d62f495a105b28ccaa212bf3c82"
    sha256 cellar: :any,                 x86_64_linux:      "636b851ba1a25bd46dda6cd826fe0e9dddd863bdfbe6227310b2b6228bea19ae"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "node"
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cryptography playwright],
                extra_packages:   %w[greenlet pyee typing-extensions]

  # No sdist on PyPI, so we use the GitHub tarball
  # Ref: https://github.com/microsoft/playwright-python/issues/2579
  resource "playwright" do
    url "https://github.com/microsoft/playwright-python/archive/refs/tags/v1.62.0.tar.gz"
    sha256 "30cc72a0c00a22c3d287539233d3d6abd579becbfe7d02aef80bd3e75c951455"

    livecheck do
      url :url
    end
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/82/e1/730125c43e3e331d98e17af3cb310ba526b3f1101b7635ca23d976ebfcf5/curl_cffi-0.16.3.tar.gz"
    sha256 "d15d0c2a35f2d75bec430c28946c2a833f421c85773bdb0795182cc5c515665b"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/1d/f1/fdedc2c75c3e31a330659c85e5793bb18b3397981fbf0844c6dee5b18926/pyee-14.0.0.tar.gz"
    sha256 "76dd0f4314ecd27f02dc73589dea7fd3853f9b6176d8ef9b122860657e3602de"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/30/9f/efe743156e717c8abc499526fd8b4c613847214cf0a8ec8741189f5a84f2/requests_futures-1.1.0.tar.gz"
    sha256 "f839cf536e6638a6e0ca1cfd54ac761bf3bb2b5a7ecf9349557e53acc5244d36"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/ef/71/ddb3c0a7a86db44d2fb3f9cbac162f7ddbcbf563b4a174963ba2b3d4d819/shtab-1.12.1.tar.gz"
    sha256 "0637338723a8fc08ed1c2fd826d8432229924649c26e3247bb48c53d60ca3bf9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/01/89/3f825ab71c242fffb62ea8fe638741c290f62f8d7aadf8125ff897747af3/websockets-17.2.tar.gz"
    sha256 "36c2fb94c990cc2545143b12690e2de6c16300f9dbe5b4f33fa300cf57dc8792"
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
    ln_sf (formula_opt_bin("node")/"node").relative_path_from(bundled_node.dirname), bundled_node
  end

  test do
    events = testpath/"events.json"
    events.write <<~JSON
      [
        {
          "id": "deposit-001",
          "timestamp": "2024-06-03T17:07:26.374+0000",
          "title": "Test deposit",
          "subtitle": null,
          "amount": {"value": 200.0},
          "eventType": "ACCOUNT_TRANSFER_INCOMING",
          "details": {"sections": []}
        }
      ]
    JSON

    output = testpath/"transactions.json"
    system bin/"pytr", "export_transactions", "--load-event-database", events,
           "--format", "json", "--no-date-with-time", "--lang", "en", output

    transaction = JSON.parse(output.read)
    assert_equal "2024-06-03", transaction["Date"]
    assert_equal "Deposit", transaction["Type"]
    assert_equal 200.0, transaction["Value"]
    assert_equal "Test deposit", transaction["Note"]
  end
end
