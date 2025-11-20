class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/1d/e0/73e86182c7cde8c4342d85d24f451b8b9cbc38688df99cbae47e8db1b476/codecov_cli-11.2.5.tar.gz"
  sha256 "e0568edd4372d863435ca8472283f90f46a6237977ded391c6b1e48c544914fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3198609e86794e5f6f856313053f4e87da2cf972085f87cc49c7bec420f7178f"
    sha256 cellar: :any,                 arm64_sequoia: "aeb88f9615ab4aa4a9907d29dc572b36a021a65614f4acb0c5158f8f9ddd3056"
    sha256 cellar: :any,                 arm64_sonoma:  "6b08167a69dc6059453b5c10eb7d60fc1f88f0d7d2128dfbf4a366bc1bae2e40"
    sha256 cellar: :any,                 sonoma:        "47f8750288d2111c72ec1101e6d51d72e24bc902500f3384b748cae556009a06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859327cbb118a7aa4c66ac4c4962865d56fe68daa1d77c318ec4207a7d54c231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75405d4e48a1b815b46cd983c7deb299bf93f52d407c8e77a483492901f64a7a"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
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
    url "https://files.pythonhosted.org/packages/2d/30/7ab4b9e88e7946f6beef419f74edcc541df3ea562c7882257b4eaa82417d/ijson-3.4.0.post0.tar.gz"
    sha256 "9aa02dc70bb245670a6ca7fba737b992aeeb4895360980622f7e568dbf23e41e"
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
    url "https://files.pythonhosted.org/packages/b3/18/09875b4323b03ca9025bae7e6539797b27e4fc032998a466b4b9c3d24653/sentry_sdk-2.43.0.tar.gz"
    sha256 "52ed6e251c5d2c084224d73efee56b007ef5c2d408a4a071270e82131d336e20"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/a5/8a/2695581eab1cffe8d3b5e25df3c04b396777135ad3a091f2d9b514a2ec77/test_results_parser-0.6.0.tar.gz"
    sha256 "8580213273b4efb357361a1e2f5e7def360c6443373970513a60d73657557912"
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
