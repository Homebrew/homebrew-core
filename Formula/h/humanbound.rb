class Humanbound < Formula
  include Language::Python::Virtualenv

  desc "Adversarial security testing engine, SDK, and CLI for AI agents"
  homepage "https://docs.humanbound.ai/"
  url "https://files.pythonhosted.org/packages/dd/df/5284e3ee04b7467426b977706539d3b2f95ee4bd0b1873d49691167b5e5f/humanbound-2.9.0.tar.gz"
  sha256 "d2f56710227546b269cd7865d634cad90f566a5ea2540deecff4e083b012b600"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "74543678ffa7ae02259dc6d3da2b5339a914416fd07a8cf63efed276c179c9ca"
    sha256 cellar: :any, arm64_sequoia: "cf92ab29f4206b2df92ce1e0181ef2aa299a55938e73178a44ae934138b9e974"
    sha256 cellar: :any, arm64_sonoma:  "00f4a6b7c5df64517ee51233f3d2fd90127f31d2798c882afdd27a12c678ac06"
    sha256 cellar: :any, sonoma:        "2630f8ba6b64236b61bf5ac887baa959d9d91b6225ca200374d146b8c785720e"
    sha256 cellar: :any, arm64_linux:   "00e9f6e098bec7b3c4ceddccc681e8abc309b40d47a701c912d7994e2cf161f0"
    sha256 cellar: :any, x86_64_linux:  "738f43c13b28c04a844d26b8966448108feec5261c09463acf7451a6423068b3"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi pydantic]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cb/31/4971872b3ed8715346231fb6eb4da8fcba65a4143c189db151ee28a2812b/charset_normalizer-3.5.0.tar.gz"
    sha256 "49bd5feb59b0bf3cbf6ebcf4352e371c95b9da9bacd4449f8b64d0ad2c10a26e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
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
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/4f/77/3737f60571995ba07677b058bb1523b7c26f28570806b8ffaf83a66df18c/posthog-7.39.1.tar.gz"
    sha256 "0d184596e35057457fc1094883646fd23de2d6338db8b9c3ea770643fb55d8a2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/hb --version")

    # reading results with none present must fail cleanly
    output = shell_output("#{bin}/hb logs 2>&1", 1)
    assert_match "No local test results", output

    # starting a scan with no LLM provider configured must fail as expected
    (testpath/"bot.json").write <<~EOS
      {"streaming": null, "chat_completion": {"endpoint": "http://127.0.0.1:9/chat", "headers": {}, "payload": {"content": "$PROMPT"}}}
    EOS
    output = shell_output("#{bin}/hb test --local --endpoint bot.json 2>&1", 2)
    assert_match "No LLM provider configured", output

    # config round-trip: writes and reads back ~/.humanbound/config.yaml
    system bin/"hb", "config", "set", "provider", "ollama"
    assert_match "ollama", shell_output("#{bin}/hb config get provider")
    assert_path_exists testpath/".humanbound/config.yaml"

    # process a results file: read a run's logs.jsonl and export it as JSON
    (testpath/".humanbound/results/exp-test").mkpath
    (testpath/".humanbound/results/exp-test/logs.jsonl").write <<~EOS
      {"thread_id": "t1", "result": "fail", "fail_category": "llm01", "explanation": "test finding", "severity": 82}
    EOS
    system bin/"hb", "logs", "--format", "json", "-o", "out.json"
    logs = JSON.parse((testpath/"out.json").read)
    assert_equal 1, logs["total"]
    assert_equal "fail", logs["logs"].first["result"]
  end
end
