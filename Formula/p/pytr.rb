class Pytr < Formula
  include Language::Python::Virtualenv

  desc "Use TradeRepublic in terminal and mass download all documents"
  homepage "https://github.com/pytr-org/pytr"
  url "https://files.pythonhosted.org/packages/05/ac/c3d75b9337f81bb3a54fa61d54d44ad4672812a6613cfb4649e221f57132/pytr-0.4.10.tar.gz"
  sha256 "41dbb9446d290fc36b21410b5547504088e7fdf49a6e637675c900ec353381d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff0dd7978d079ca3419445b04b392dd408fe1f0ca7340f3d1ed135e356767812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2b5787e79e832821ea7f02533dbdecb5ab573c6ea662162b63ba07d7d1672d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b69a562854b7e7d824155997bc969fbd965e9d36ec1143fa784f89aaf0526846"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e62397faaf36d50f1f150980c7c63e1308cb681173f4f3055daec9f576e04e8"
    sha256 cellar: :any,                 arm64_linux:   "ece585b389693d8f425a6f4809d8b2a58986e9608f9c3956353064fca4363ae7"
    sha256 cellar: :any,                 x86_64_linux:  "86c3a0e855c59609371e6839f8dd61b5d374d5f310409f57510125b2d947f501"
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
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/b4/23/d32e113b16dbfb458bea408871ed98dd12f306a366a04215e84537e0af7e/curl_cffi-0.16.0.tar.gz"
    sha256 "b00b423da8028eb6221e3b63bcd63d681150c07cee8b16000d1f7ea292731895"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/a3/74/b13368064b09053253555d3f2839cc2684d22d5aed0d2ccffbf7a6736558/greenlet-3.5.4.tar.gz"
    sha256 "0232ae1de90a8e07867bb127d7a6ba2301e859145489f25cda8a6096dabe1d20"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/8b/04/e7c1fe4dc78a6fdbfd6c337b1c3732ff543b8a397683ab38378447baa331/pyee-13.0.1.tar.gz"
    sha256 "0b931f7c14535667ed4c7e0d531716368715e860b988770fc7eb8578d1f67fc8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/88/f8/175b823241536ba09da033850d66194c372c65c38804847ac9cef0239542/requests_futures-1.0.2.tar.gz"
    sha256 "6b7eb57940336e800faebc3dab506360edec9478f7b22dc570858ad3aa7458da"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/fb/79/789eac85ffa705c1405e8524bd99b88b882b4495cd6d2bf30bfa9af909e7/shtab-1.9.3.tar.gz"
    sha256 "76d9b980cb7fca90b808380f9f1d251f37891d1abc30e1d63f6bde030f804c02"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f7/96/e01084f83a64bcb3a27994bd0cb0db68ff29d9c6707fae37ec19b18ba990/websockets-17.0.1.tar.gz"
    sha256 "5baa9bc0dfbae8c507e51c8cf1b6d4628086f7a87bbd3a9952bd5f035451f1cc"
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
