class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0355fb26042e05634af6076e5c9336cddaeec720ab572d61a0613347b4dc780b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1b956ec838657fd1a7f6f4ef7be531bc97ee31177c1f7d9f437de44036b7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db73b2bc8747894c0de6c98c655c47257edd9223c4d6e031bc03096036a8b4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "93bc6e827ae0cfe7e1a1489a800e4ce0335f894a5e172cbb250068903515d547"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec4c546080f4d5f2420ff5b43901e2aa5fe86effd609cc1028a995f32eb4fe2"
    sha256 cellar: :any_skip_relocation, monterey:       "b5fe7a2ff676ee4a6f1413da4a77fadbbcb03852e6b55b2af5891f0c02f16386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ef3f8efbb2448c1ce1f601b1852fddd4e4ee25e663a59444e09b15ddf031e5"
  end

  depends_on "python@3.12"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
        echo "Testing Bashate"
    EOS
    assert_match "E003 Indent not multiple of 4", shell_output(bin/"bashate #{testpath}/test.sh", 1)
    assert_empty shell_output(bin/"bashate -i E003 #{testpath}/test.sh")

    assert_match version.to_s, shell_output(bin/"bashate --version")
  end
end
