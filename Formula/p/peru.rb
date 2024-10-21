class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/fe/0e/b78315545923029f18669d083826bc59a12006cd3bc430c8141f896310cc/peru-1.3.2.tar.gz"
  sha256 "161d9fd85d8d37ef10eed1d8b38da126d7ba9554b585e40ed2964138fc3b2f00"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3a505d5ae83c37d1c03a701730080b6c5ea64845e49e5b559092f8e456f7861c"
    sha256 cellar: :any,                 arm64_sonoma:  "3f43433b133723e78ac768cbbf3cdf75727ec56ce717d0032b5a477c5b108933"
    sha256 cellar: :any,                 arm64_ventura: "6ad7e31af06a24c12d7554db4cc6484efcc36ea223eb55b58f6afb1c44564159"
    sha256 cellar: :any,                 sonoma:        "1f1cb4aff42105b14711d19944b4d7fe8d0f35ccf4d7f473e762605770adac1d"
    sha256 cellar: :any,                 ventura:       "ed6ef91406a4e6391239f3d8a9d4608bb2f9c3133051c11b088bdaa64fcb365e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b15bfa66cac8e7e571c11213ab84b55d5deb0de4d742d94b36c489ba63349e"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

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
    (testpath/"peru.yaml").write <<~EOS
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    EOS

    system bin/"peru", "sync"
    assert_predicate testpath/".peru", :exist?
    assert_predicate testpath/"peru", :exist?
  end
end
