class Apprise < Formula
  include Language::Python::Virtualenv

  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/a4/92/461f16f50118a99953aed66d5c1c5dc462261bd6cca15862f2eae7b5fcf5/apprise-2.2.0.tar.gz"
  sha256 "711382b7c366e575276863da72f5473e34db1735a9980f6df464b337a8003ebc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4635ca46b2af2881b5e6ea9d46837f6d09943b8033324130a34e1cb20b443270"
    sha256 cellar: :any, arm64_tahoe:       "a44e247f607d3811badc0926642bb0ba0dae365659e0cf5510d127e58056d011"
    sha256 cellar: :any, arm64_sequoia:     "08dd79ca3f85b625ac45dc09f696079f19577baf363cea759bb94782986d8152"
    sha256 cellar: :any, arm64_linux:       "c1efbe8683d37f057a7a4081a1941fd03db770eb864887907251c9e8026635c0"
    sha256 cellar: :any, x86_64_linux:      "9ce94bfb4526f3ee9f0782f47c75e61535dbd5efd318d2518146b7f40a086cbc"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/ca/eb/dc0fd6eff604bfb870b7fb68b90985a32caaf3c76f67736bbf7f438acd59/markdown-3.11.3.tar.gz"
    sha256 "81eb91631dc97ad1efbc76019ef0f80fe90ca49ddf81546752d79989c3bfff3e"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"apprise", shell_parameter_format: :click)
  end

  test do
    # Setup a custom notifier that can be passed in as a plugin
    file = testpath/"brewtest_notifier.py"
    file.write <<~PYTHON
      from apprise.decorators import notify

      @notify(on="brewtest")
      def my_wrapper(body, title, *args, **kwargs):
        # A simple test - print to screen
        print("{}: {}".format(title, body))
    PYTHON

    charset = Array("A".."Z") + Array("a".."z") + Array(0..9)
    title = charset.sample(32).join
    body = charset.sample(256).join

    # Run the custom notifier and make sure the output matches the expected value
    assert_match "#{title}: #{body}",
      shell_output("#{bin}/apprise -P \"#{file}\" -t \"#{title}\" -b \"#{body}\" \"brewtest://\" 2>&1")
  end
end
