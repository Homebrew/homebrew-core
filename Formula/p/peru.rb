class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/0e/96/dc9e467f61327b686b6e775ecf7e365011c44fd25b34114de926dfb54f15/peru-1.3.4.tar.gz"
  sha256 "2ff19ae8569b783177d5cf9fb6c0e306698f7397603f2fdf4a0672d15f7dbd73"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "beeb4f77adc52280a01149f9cdfd3b4100d6c7dd92c51aa6fb59b4a4c1d50bd9"
    sha256 cellar: :any,                 arm64_sonoma:  "6bcea08bb842546b71b214f6390e8cc31eff4b778000d178472526199a231b66"
    sha256 cellar: :any,                 arm64_ventura: "b013421dad16894ef27b69c705cc52b729eaa7b404c70cd926b755c6ec11c461"
    sha256 cellar: :any,                 sonoma:        "374514a3186c7992d46046a34c5293d75ca9681b767cd2a4a39d112a7e2ddc15"
    sha256 cellar: :any,                 ventura:       "1ade107c73338fe0a62805099cc16d53e59ba95009055c01d6def097c4928dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe0da4736ccecc7dd1b2609e57f76e1eeeddbac408f7d3cd83bb204220173e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ed2401a2819caa9197b706d000b153c1893036ff291ca64e6b65bd949248ef"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.13"
    end

    virtualenv_install_with_resources
  end

  test do
    (testpath/"peru.yaml").write <<~YAML
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    YAML

    system bin/"peru", "sync"
    assert_path_exists testpath/".peru"
    assert_path_exists testpath/"peru"
  end
end
