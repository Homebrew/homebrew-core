class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/a8/45/cec03aca5ab8a8a1ff8248dcd5c9f17e5a7e9c9e8e9d0b9a135a1c0605e7/peru-1.3.3.tar.gz"
  sha256 "ac6b0d0e85fbe7d57d4587b4e58551de83fd4af4f8245a0851414898cce3e1b1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd7035d7b44788659c3c228fdbca57d6f918799469ca542046e70b64465e3855"
    sha256 cellar: :any,                 arm64_sonoma:  "124352399f26fd9fdc5a396a33f6f624ef613eb7a5eb07b50aac7262ac12a0c3"
    sha256 cellar: :any,                 arm64_ventura: "ad488293d43ee05ac8eccf9e5278e7613b26a8ac960b1385d128fa78e1465f15"
    sha256 cellar: :any,                 sonoma:        "e575c707cc3431e180e541d516812c8f4303adfd3e786198da14f4af7c27ddc5"
    sha256 cellar: :any,                 ventura:       "45a48b49b8eef723df7537615fb968eb984c1c6e6a4a44634177c3ce35b367d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ab93c07fc0d53f07452e107fa9352fc3a269a608f0284a4baa41369c9e6257"
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
    assert_predicate testpath/".peru", :exist?
    assert_predicate testpath/"peru", :exist?
  end
end
