class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/38/26/bdd962d6ee781f6229c3fb83483cf9e09d87959150a9000789806d750f3c/bandit-1.7.10.tar.gz"
  sha256 "59ed5caf5d92b6ada4bf65bc6437feea4a9da1093384445fed4d472acc6cff7b"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a773798dbfadc5fec12de44bf1b06d1a01df4eaa4223a0edcabc5fad80fb6ac5"
    sha256 cellar: :any,                 arm64_sonoma:  "2954286ef2ceec08925a604763a86fe7e8a200a177eb7ca19a488ebc03b64155"
    sha256 cellar: :any,                 arm64_ventura: "06c6654ab52bee3037373055ae8cc53c10b656099ab5e30b9202545318833d9a"
    sha256 cellar: :any,                 sonoma:        "1b50299811ae6ff87887a87e48cd771fa4c1a5cfbfc63e2d300adcb5ffde5ed0"
    sha256 cellar: :any,                 ventura:       "ae30f72cc3f66b78de593710e083c656d1d547406139dd8f6fb404482c8166fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f26864e92086e87e571e601bd7993ed18f6d92897c48b4116091987233ec28"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/b2/35/80cf8f6a4f34017a7fe28242dc45161a1baa55c41563c354d8147e8358b2/pbr-6.1.0.tar.gz"
    sha256 "788183e382e3d1d7707db08978239965e8b9e4e5ed42669bf4758186734d5f24"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/aa/9e/1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95/rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/c4/59/f8aefa21020054f553bf7e3b405caec7f8d1f432d9cb47e34aaa244d8d03/stevedore-5.3.0.tar.gz"
    sha256 "9a64265f4060312828151c204efbe9b7a9852a0d9228756344dbc7e4023e375a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end
