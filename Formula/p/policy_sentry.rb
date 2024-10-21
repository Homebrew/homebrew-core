class PolicySentry < Formula
  include Language::Python::Virtualenv

  desc "Generate locked-down AWS IAM Policies"
  homepage "https://policy-sentry.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/52/4f/02922c178ca4acbe21f5d1252209ccc05bb70d515ca406925ae7e34e164f/policy_sentry-0.13.1.tar.gz"
  sha256 "6bb0133d897a45349aed78942459b4f583542051bb181e3a64464d13af8190b0"
  license "MIT"
  head "https://github.com/salesforce/policy_sentry.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9d7ab42b3cc3cd0f619594e79e73f163b9dc24c94f23018ef0f9e67568a66267"
    sha256 cellar: :any,                 arm64_sonoma:  "2f125bd2113536a97c523827b359270e95edc941b2e91a56d4da7fefe0f1ed52"
    sha256 cellar: :any,                 arm64_ventura: "3febd59cedf3aea33af3560e1b4d2e47e7ff0d69f1e5adedb80fd8f113f0c010"
    sha256 cellar: :any,                 sonoma:        "191fa81f65ae9379736413106bb1253e0f37d4270252700fbf0db2e8b50d9e3f"
    sha256 cellar: :any,                 ventura:       "9253304ecff6fbfacc5a1065b7cd7c1f5caafb4d283253825615d12b6a37b2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4f96d2c2f624bbe53a1d18e1cb181cc66cbb9515ae420fd133abe95dcc5f5dd"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/9e/03/821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845/orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/d4/01/0ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecd/schema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy_sentry --version")

    test_file = testpath/"policy_sentry.yml"
    output = shell_output("#{bin}/policy_sentry create-template -o #{test_file} -t actions")
    assert_match "write-policy template file written to: #{test_file}", output
    assert_match "mode: actions", test_file.read
  end
end
