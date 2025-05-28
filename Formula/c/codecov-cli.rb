class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/07/d7/1e35265fb197cfebc95b481d5d3d7502b0ff4e2bdc33096dbe06f7429ecb/codecov_cli-11.0.0.tar.gz"
  sha256 "567b4b8c1608d3365f99aa13c6a95320c72f60a75bea7fc1fc9b1bc58a0214a6"
  license "Apache-2.0"
  head "https://github.com/codecov/codecov-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e8700b6294a78bfdd5b672c8918c22884233371d5669fdd65cbbb2fe1c2e215"
    sha256 cellar: :any,                 arm64_sonoma:  "92e260e344d605a9099b12d15fb3038f1008773e5a2deaa042a6621b7b73b067"
    sha256 cellar: :any,                 arm64_ventura: "3e69185f615d42da45340bd4f22c5fba69ed40c50ff27f083dfbf0e2b71642de"
    sha256 cellar: :any,                 sonoma:        "b9049f08ce0b34be9097132c53f9cb1e5c257f99ddc05745e274ac58ca9817e8"
    sha256 cellar: :any,                 ventura:       "81ac401e3f53967fbf917ca82f15f3a7a7c218353de805734cf42ce6bf6b0dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69fd759c477c6f51258e0c1db469864e663132b9d9b85b4ccaa0adc081802f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8005b97f7348989ce2069f825f6a0f9ad4e817f83da7a52a5cae4951506f87bd"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e8/9e/c05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4/certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/a3/4f/1cfeada63f5fce87536651268ddf5cca79b8b4bbb457aee4e45777964a0a/ijson-3.4.0.tar.gz"
    sha256 "5f74dcbad9d592c428d3ca3957f7115a42689ee7ee941458860900236ae9bb13"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    url "https://files.pythonhosted.org/packages/22/67/d552a5f8e5a6a56b2feea6529e2d8ccd54349084c84176d5a1f7295044bc/sentry_sdk-2.29.1.tar.gz"
    sha256 "8d4a0206b95fa5fe85e5e7517ed662e3888374bdc342c00e435e10e6d831aa6d"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/e9/25/c6459ae54e5b57944417a8f72662d186ab43b0eae956193d6de281619ce4/test_results_parser-0.5.4.tar.gz"
    sha256 "2fbfd809a2c1f746360146809b6df30690c992463d7d43e7b1fed31c1a7c15b4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
