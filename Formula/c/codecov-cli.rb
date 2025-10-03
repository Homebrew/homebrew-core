class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/cf/93/57e484d41082818a91badfd64f31618431a0c55eeadbc1dde41f2ee4f6b7/codecov_cli-11.2.3.tar.gz"
  sha256 "89cd48341b3fd7941760336d0fa03d99ee1a4cb262ac85d5e04089e5a25688e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aadf4a2374a70c622f052384d113d8354bb3fcf30ab73ebcb2a9abe84cccbabc"
    sha256 cellar: :any,                 arm64_sequoia: "1b7f0687fb22a9c30a5bf317d94723571936d5db1b57c14bf9604c5f00f439d3"
    sha256 cellar: :any,                 arm64_sonoma:  "31834fac73197d3975472fb1554abdcc9a45007c6c5e038e4f46ae1204080e6f"
    sha256 cellar: :any,                 sonoma:        "36814402660c424350c8bad7e7695bd28386edf02d34e99535799ac881d817ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f996e37fc3fc0885ebefcee1379e2e2d7a1cd62226dff5e11d7690c858f4d6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7f54d7a4cbaf271554dc5388575e1193d440565e20f79f9e089af9f9062852"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
    sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/b2/22/60fd703b34d94d216b2387e048ac82de3e86b63bc28869fb076f8bb0204a/sentry_sdk-2.38.0.tar.gz"
    sha256 "792d2af45e167e2f8a3347143f525b9b6bac6f058fb2014720b40b84ccbeb985"
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
