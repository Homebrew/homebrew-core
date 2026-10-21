class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/b8/c3/d097b669f1d794d956e4afc52cf5d2ce3d1d0bc42cb3505092fbb5b4d319/codecov_cli-11.3.1.tar.gz"
  sha256 "316bd39d0e90491b9bd609bc4ad0c2c037ee9c724faf4b2b72c1f70755d4e616"
  license "Apache-2.0"
  revision 2
  head "https://github.com/codecov/codecov-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "668a065c5a554ef24ead2cb3648f9c5d2f9e3825e80cf4dd152bc0cd798a091c"
    sha256 cellar: :any, arm64_tahoe:       "fda0028173dfe586602db977250e87ff2dbaca9bd4b674a82350546a8cd92e59"
    sha256 cellar: :any, arm64_sequoia:     "e46bfe5d0fd9d8b9711a3a82a156e59456698a256196a584b50208283b2f84c8"
    sha256 cellar: :any, arm64_linux:       "a2029da4705290ee2a21f486e329d58d42e95560237299d6d6ca6c58f4d5792a"
    sha256 cellar: :any, x86_64_linux:      "b7a95e1cae8a19911bc2f7acfa4e1e6b3d2960f6da096d7fde247180ef03763e"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/3a/06/b31f040a8764336a11152e474a7abcb3782fedb0d1cdf78f442b82878c56/ijson-3.5.1.tar.gz"
    sha256 "af40bd1a85f55db0b8b30715c858761306bd92d5590148636f75c3309e6e76bd"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/67/93/9ef70bfb7346c778caf09b7cd10c17c33f601f2d17019fa1aedcda738b5f/sentry_sdk-2.71.0.tar.gz"
    sha256 "7beb27a22f06396f3a05510c3da6ea10e1c79e02e859993c27ce4ff074e296d6"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/e4/bd/ee2278f92c6fdee1490c9dacd3ab5d6cdf61a26de988465723f52c17fb03/test_results_parser-0.6.1.tar.gz"
    sha256 "5ea92dc7ae84bd89e9c3fc375317d85c981f9d139c3cca1b0afe16d96e34e7f6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  allow_network_access! :build

  def install
    # TODO: Remove when test-results-parser supports Python 3.15: https://github.com/codecov/test-results-parser/issues/97
    ENV["PYO3_USE_ABI3_FORWARD_COMPATIBILITY"] = "1"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"codecovcli", shell_parameter_format: :click)
  end

  test do
    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}/codecovcli --version")

    system libexec/"bin/python", "-c", <<~PYTHON
      from test_results_parser import Outcome, parse_junit_xml

      result = parse_junit_xml(b'<testsuite name="example"><testcase name="success" time="0.1"/></testsuite>')
      assert len(result.testruns) == 1
      assert result.testruns[0].name == "success"
      assert result.testruns[0].outcome == Outcome.Pass
    PYTHON

    (testpath/"coverage.json").write <<~JSON
      {
        "meta": { "format": 2 },
        "files": {},
        "totals": {
          "covered_lines": 0,
          "num_statements": 0,
          "percent_covered": 100,
        }
      }
    JSON

    output = shell_output("#{bin}/codecovcli do-upload --commit-sha=mocksha --dry-run 2>&1")
    assert_match "Found 1 coverage files to report", output
    assert_match "Upload queued for processing complete", output
  end
end
