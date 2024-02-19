class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/c7/c451e70443c0b82440384d51f4b9517b921d4fe44172d63dc10a09da114f/peru-1.3.1.tar.gz"
  sha256 "31cbcc3b1c0663866fcfb2065cb7ac26fda1843a3e5638f260cc0d78b3372f39"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3a3207338ecad0cd931a107c740d7ddf5f0e537be63e2309811863ae739e2cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8211cf9d13b6f77b2bc42addba25baa30234c28adbe42875e52ab8bd4fe9ff63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3407e87d02d47049d5371e9df63b8efea19deda00c0a3d5414c1a4e4880f6179"
    sha256 cellar: :any_skip_relocation, sonoma:         "7aef8abb72ca0464ea248cdc98e17b3ab086af2420d131a629917b257264b890"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb7705fec41c76c1b307784361196a3225f99ff3816d7fab0267c310e9ff7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "6f29ade0026f94290f91c6715d217aa3e0213bb9e69ccb3153372460cce3be96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a046dce60f8571919aecb130b33666834dc125e31d3a52498ffe457c1ac1a9ce"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.12"
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
