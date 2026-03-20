class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/d9/6a/49acd54e67271b2e628f9df109f17ca92e274ba6563c58968badda353578/codecov_cli-11.2.7.tar.gz"
  sha256 "dc8309d785ceecdd8f10c06958d2727936e500411f3d80e3b90c05c604cde584"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78e66f379b5951bf65acd031a64676df9d9a580cfb7e138b3161ecf9cc1ae080"
    sha256 cellar: :any,                 arm64_sequoia: "dc7b2dbb9016945567bfaae9fc701a4a99441f6c30b897a541a4649e041fd3ef"
    sha256 cellar: :any,                 arm64_sonoma:  "010cb0469956ddfd4e35106e571f58c0c9bff5809b656fe514336000d8ba0fba"
    sha256 cellar: :any,                 sonoma:        "307c6e1878c4afc459bf3ad46f4d394f455fa4f4bb2a0622454154ddba06a61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6392d5d6f687bea84e8e28f05b6652944149a850ceed3a36ca4d594738378e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a925abe37a7affea88ec314bdd0873d84553196a5efb3cd7e0a2d29a1920c7"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/f4/57/60d1a6a512f2f0508d0bc8b4f1cc5616fd3196619b66bd6a01f9155a1292/ijson-3.5.0.tar.gz"
    sha256 "94688760720e3f5212731b3cb8d30267f9a045fb38fb3870254e7b9504246f31"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/e9/b8/285293dc60fc198fffc3fcdbc7c6d4e646e0f74e61461c355d40faa64ceb/sentry_sdk-2.55.0.tar.gz"
    sha256 "3774c4d8820720ca4101548131b9c162f4c9426eb7f4d24aca453012a7470f69"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/e4/bd/ee2278f92c6fdee1490c9dacd3ab5d6cdf61a26de988465723f52c17fb03/test_results_parser-0.6.1.tar.gz"
    sha256 "5ea92dc7ae84bd89e9c3fc375317d85c981f9d139c3cca1b0afe16d96e34e7f6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"codecovcli", shell_parameter_format: :click)
  end

  test do
    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}/codecovcli --version")

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
    assert_match "Process Upload complete", output
  end
end
