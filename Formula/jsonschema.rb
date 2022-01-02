class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/23/ba/625e677a029a87200e5c7892760c6d4660bab4fe7720d0b94bb034a24fc7/jsonschema-4.3.3.tar.gz"
  sha256 "f210d4ce095ed1e8af635d15c8ee79b586f656ab54399ba87b8ab87e5bff0ade"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083afbdda72e6350deb0014b3d703e17e577d90899ef5f2a77b777203167990c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e15dd5ff66105d6cb993a02520ee38bc613ea86b5f7b99aab962d945a996c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4adb19281eb9a22e6e86168d9dd7cff6b618346fa16ca625823996e0c9b950"
    sha256 cellar: :any_skip_relocation, big_sur:        "37efdefdfe096f44c4bd59077c187beb063cae18f74373c3bd6abeddc70debc4"
    sha256 cellar: :any_skip_relocation, catalina:       "811fbca8e0de511e59cbf6e49dc8d4155e040928c47a19bd2aae2db6dfd8b0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7a3ab6ea6898e2dd73a19aaaa81aa9b3adfb77fa52c529637415454582d4bf"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/jsonschema --output pretty --instance #{testpath}/test.json #{testpath}/test.schema")
    assert_match "SUCCESS", out
  end
end
