class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/03/28/34c9ddb39e1e50db34b07a73af423978641b84f66ea437f6c40b03e5d5a5/peru-1.2.1.tar.gz"
  sha256 "4d2f30c71343ae2692f403b465b04a97c110d4126a3fa59cb42b25243cb24064"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "b8d5f0915d0f6b7a0ce49ffc61a0503b809ac6c074d2057d2f1396ea0788de67" => :big_sur
    sha256 "171980304c1aa1545f2397ecc9adcedd3f84b533974265d243a88ba2ccd36de0" => :arm64_big_sur
    sha256 "927f2ddcf69404fde76a587d8797eb6937d206b6f79ee05615bf55788f82dd6c" => :catalina
    sha256 "8d48227b9184a9f0f623a799a91179e1f24e456507b802c5e620594f7104e940" => :mojave
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
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
