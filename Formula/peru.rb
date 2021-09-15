class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/d5/40/d97b481076e7691bb7593bfbce209d64da7fb17d1fc5c170fe7a656dbb03/peru-1.3.0.tar.gz"
  sha256 "e70f11633422ac95595f943e693f3b72da0ac852b9b43220e04096c92d5d2c35"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "aa4a20ed7347ab1cf91c6adc484279ca27d17f7b65f23d25be4b63f283491f7c"
    sha256 cellar: :any,                 big_sur:       "bcc6478c675786f51934108b92b5e47d2798dc2a4b0ef8bfae99f130fa2f473e"
    sha256 cellar: :any,                 catalina:      "31220d37966a4dc4edb016b44a80e70ca291c669ed56176dc08b00eeeeafe683"
    sha256 cellar: :any,                 mojave:        "c0e0c051d79f223765f095524f5fea92fd5275c51d2f59281d12e9456e9ee2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe15d9a12d971f7a0be3ee5a132fc2d4482f70e20578ecacdab13dad15fc8b58"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.9"
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
