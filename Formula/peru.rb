class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/c7/c451e70443c0b82440384d51f4b9517b921d4fe44172d63dc10a09da114f/peru-1.3.1.tar.gz"
  sha256 "31cbcc3b1c0663866fcfb2065cb7ac26fda1843a3e5638f260cc0d78b3372f39"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33781e91b6ffa754ccb1f3b3df42fb627325ce6809ff9a42941fc67ba0740d82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33781e91b6ffa754ccb1f3b3df42fb627325ce6809ff9a42941fc67ba0740d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33781e91b6ffa754ccb1f3b3df42fb627325ce6809ff9a42941fc67ba0740d82"
    sha256 cellar: :any_skip_relocation, ventura:        "f94520f666b3acef6644b3ea43b4d9327b28ca45cfd822909e8010ab6d6e6834"
    sha256 cellar: :any_skip_relocation, monterey:       "f94520f666b3acef6644b3ea43b4d9327b28ca45cfd822909e8010ab6d6e6834"
    sha256 cellar: :any_skip_relocation, big_sur:        "f94520f666b3acef6644b3ea43b4d9327b28ca45cfd822909e8010ab6d6e6834"
    sha256 cellar: :any_skip_relocation, catalina:       "f94520f666b3acef6644b3ea43b4d9327b28ca45cfd822909e8010ab6d6e6834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2016883c0c26a317caf13e96965be03c97df01e67543a4d9a903477c0571313"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.11"
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
