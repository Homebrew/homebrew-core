class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/3a/7e/7d916fa02a49d1f16fbb74498bdb95d005d008eb9792626b2468336297cb/codecov_cli-11.0.3.tar.gz"
  sha256 "0a6d92f51bc6bfb3c5bb6b59722ba3c32e1325f2d23562b4596e2c93782cadad"
  license "Apache-2.0"
  revision 2
  head "https://github.com/codecov/codecov-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec5fafb332973aa8663135efabd0d6091e9293faa713635ea4c5d850d4938bab"
    sha256 cellar: :any,                 arm64_sonoma:  "c5f5670939d0b311cbc377dc8b953ffc02847d3bc1d69140f7a66a6aeff50415"
    sha256 cellar: :any,                 arm64_ventura: "037551e31a523c03eb00779d6894bc1ce53c5a0702966903792c7832d4519a25"
    sha256 cellar: :any,                 sonoma:        "9598ff14e6f0b89c651d1c6a2c25738ad07983ea20a9b8228a5b9ec6f3195e6e"
    sha256 cellar: :any,                 ventura:       "cf57b5b73b4e64a01ee1c07531d3b5928e0ab118326fac7050806f41a9d98504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9bfd2caec063ad05d8b405dbb5f61dc93f0d8012e548e0d62e7da3dffea90d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45124a3898a9ff63ecf1e7919fd2ef88ea9b122a4e32d1262406cd8e2a509021"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/73/f7/f14b46d4bcd21092d7d3ccef689615220d8a08fb25e564b65d20738e672e/certifi-2025.6.15.tar.gz"
    sha256 "d747aa5a8b9bbbb1bb8c22bb13e22bd1f18e9796defa16bab421f7f7a317323b"
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
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/04/4c/af31e0201b48469786ddeb1bf6fd3dfa3a291cc613a0fe6a60163a7535f9/sentry_sdk-2.30.0.tar.gz"
    sha256 "436369b02afef7430efb10300a344fb61a11fe6db41c2b11f41ee037d2dd7f45"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/e9/25/c6459ae54e5b57944417a8f72662d186ab43b0eae956193d6de281619ce4/test_results_parser-0.5.4.tar.gz"
    sha256 "2fbfd809a2c1f746360146809b6df30690c992463d7d43e7b1fed31c1a7c15b4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"codecovcli",
                                         shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
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
