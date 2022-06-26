class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/c7/c451e70443c0b82440384d51f4b9517b921d4fe44172d63dc10a09da114f/peru-1.3.1.tar.gz"
  sha256 "31cbcc3b1c0663866fcfb2065cb7ac26fda1843a3e5638f260cc0d78b3372f39"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "17d3e1e942f39a015aab23a4e5c685184e850d685e36856d2efff8a75b3f7c4a"
    sha256 cellar: :any,                 arm64_big_sur:  "e1a41254b6275b19f0f5446efebf78e8c73b7751b6fb69bbe54ec04e163edb95"
    sha256 cellar: :any,                 monterey:       "bdc29ff32a6d50c51dcf23202b23d4b1118f3cbfa7aad73d3cd3aab341d7f8f5"
    sha256 cellar: :any,                 big_sur:        "34b20f349d92f5fa498dc98a44ca5207597a3d8e1d1f10869b5ca13b306828a9"
    sha256 cellar: :any,                 catalina:       "03e13962e7411e3b81f1cd92b79932ccb5e8ac65999d7cae4a2d7c6e6619669e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2f9f55d91a612232221a8419e76538faa8ac290e461a60dd2c60c4f6283ad0"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.10"
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
    system "#{bin}/peru", "sync"
    assert_predicate testpath/".peru", :exist?
    assert_predicate testpath/"peru", :exist?
  end
end
