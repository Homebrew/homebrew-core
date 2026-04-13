class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/5d/a6/7de4ab8ac19a3ab83b1844173c5dc4a819c55f7fa6c2dc7aa7c47ada6075/codecov_cli-11.2.8.tar.gz"
  sha256 "39daded2fe9f618fdd7e249891d5cb1e4fb413c203b8a83d5d0f79c18b674ac4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f0a21976be9137aed84edd7de9ad202f1a8e06d2d72ae7337e736916ece7902"
    sha256 cellar: :any,                 arm64_sequoia: "172e10574e99f0e0620b485a622c42c277ecb9d01e380e88427ed3f914d9412f"
    sha256 cellar: :any,                 arm64_sonoma:  "43235d1861700d54861faa4960de0322d3a4019058381153e14f902528361180"
    sha256 cellar: :any,                 sonoma:        "a6b6146c719cd216d46272ad472e57e11c1c68774ba98da847dff4ceec1ab14f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c677fd4021e33d51436253592bf88650e4ed06c75e12c0721b8f0104c3ac04fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82183f08fe26933a10e97e0249582714417e897f2c286616ab0aec6b1ddc29f1"
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
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/de/df/5008954f5466085966468612a7d1638487596ee6d2fd7fb51783a85351bf/sentry_sdk-2.56.0.tar.gz"
    sha256 "fdab72030b69625665b2eeb9738bdde748ad254e8073085a0ce95382678e8168"
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
    assert_match "Upload queued for processing complete", output
  end
end
