class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/da/06/3f623cb42b0a9f6bb050a82fdb3ba6611e91859f0806dd3abcfd12f6a30f/codecov_cli-10.0.1.tar.gz"
  sha256 "6c91dbdada1c26c3ff261c8c23edc0fb1de6eac24d8037b5917113ed68218543"
  license "Apache-2.0"
  head "https://github.com/codecov/codecov-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc6471330bab9738c952308ce513e646be357b5c3855e3443ae6706e467e1442"
    sha256 cellar: :any,                 arm64_sonoma:  "552f1dedb3a697150794c5a7f91c3568a99f59551a4f215ec643ab29fa43bd7c"
    sha256 cellar: :any,                 arm64_ventura: "5ef3b77a12da7c4f452ffbfb012c34f9689f63aea9b762ef2739512db2845e67"
    sha256 cellar: :any,                 sonoma:        "5f9c6b7ea387f4b305d700e53625e8bf4f6d65bc44f7dc3c7719c6b3c5541fca"
    sha256 cellar: :any,                 ventura:       "bfa97d5f294c4843fdec1aef085ed6848a140cffefe4f7f3eb8aaa6746d72c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abdaf7fd3173f574a810f25396b3a63d92acdc9c90cc180cb55719f5a4261409"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a3/73/199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cde/anyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/0f/bd/1d41ee578ce09523c81a15426705dd20969f5abf006d1afe8aeff0dd776a/certifi-2024.12.14.tar.gz"
    sha256 "b650d30f370c2b724812bee08008be0c4163b163ddaec3f2546c1caf65f191db"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/6a/41/d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90/httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/6c/83/28e9e93a3a61913e334e3a2e78ea9924bb9f9b1ac45898977f9d9dd6133f/ijson-3.3.0.tar.gz"
    sha256 "7f172e6ba1bee0d4c8f8ebd639577bfe429dee0f3f96775a067b8bae4492d8a0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/68/e8/6a366c0cd5e129dda6ecb20ff097f70b18182c248d4c27e813c21f98992a/sentry_sdk-2.20.0.tar.gz"
    sha256 "afa82713a92facf847df3c6f63cec71eb488d826a50965def3d7722aa6f0fdab"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/a6/4d/2df785a23ccec80f427a61e5dcb6ecde5884cdd57b964fafbfe90e40d741/test_results_parser-0.5.1.tar.gz"
    sha256 "0da5124eee0783d49b27005ddcf94c708026fe8eb7435c8ce44edd5716cec0cf"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/4a/64/71b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4/tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"codecovcli", shells: [:fish, :zsh], shell_parameter_format: :click)
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
