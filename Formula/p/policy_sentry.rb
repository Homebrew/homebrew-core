class PolicySentry < Formula
  include Language::Python::Virtualenv

  desc "Generate locked-down AWS IAM Policies"
  homepage "https://policy-sentry.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2c/62/5ef0720302fff4a3b194c99ee7c6570a7b8086589588f2d5aab352deee35/policy_sentry-0.14.1.tar.gz"
  sha256 "dda37098a5e8038c5d8a0e6b4e644736cd3cfec167b53007604dd92f8a20ea97"
  license "MIT"
  head "https://github.com/salesforce/policy_sentry.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "074c4f24407743d54fe65753e32551173039fe70238ef9e292f820051f9911a0"
    sha256 cellar: :any,                 arm64_sequoia: "b7bb0431dcc36eabe84332acf12e394fa800c83fdf1e715db1bf7a4d47576e09"
    sha256 cellar: :any,                 arm64_sonoma:  "3ea133ab0ab3b812fa6ab471717a6a1d17bce667ccff44dd77f3f7416cc259e8"
    sha256 cellar: :any,                 sonoma:        "bd2b002cb6d4ff8331a42ac75149b4bfe350982ca6ab7c93d50b5f09a6baeb9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0144de03e26e755cc384c6d2e4c2f46879aaa8c015d8db37293c02edd56845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c123cbc2db34118ccbcb47142f16fbccfe30d57bfb6d802a163bb513c1f4839"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/be/4d/8df5f83256a809c22c4d6792ce8d43bb503be0fb7a8e4da9025754b09658/orjson-3.11.3.tar.gz"
    sha256 "1c0603b1d2ffcd43a411d64797a19556ef76958aef1c182f22dc30860152a98a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"policy_sentry", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy_sentry --version")

    test_file = testpath/"policy_sentry.yml"
    output = shell_output("#{bin}/policy_sentry create-template -o #{test_file} -t actions")
    assert_match "write-policy template file written to: #{test_file}", output
    assert_match "mode: actions", test_file.read
  end
end
