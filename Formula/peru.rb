class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/c7/c451e70443c0b82440384d51f4b9517b921d4fe44172d63dc10a09da114f/peru-1.3.1.tar.gz"
  sha256 "31cbcc3b1c0663866fcfb2065cb7ac26fda1843a3e5638f260cc0d78b3372f39"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "349fa7e31f5fa27ba30502178d18d0130541d0c39cb62e928d4ecfe722b47550"
    sha256 cellar: :any,                 arm64_big_sur:  "10bb71d1c3053196036bf75ea13605541101f74ca00fc27902718d99195e9432"
    sha256 cellar: :any,                 monterey:       "637a62572a9a3fb106f6a0fcc809bbe9dc5dae3ee51dbfc136a8f5382c6f1e69"
    sha256 cellar: :any,                 big_sur:        "d48061587fc2627b0584dcf23438c3097e280564955adb5f556023cad7ca46b1"
    sha256 cellar: :any,                 catalina:       "4fac7c1d51da92f85bb3b3be8f328d72154a6372cdc59864faae8d6c6f98baa7"
    sha256 cellar: :any,                 mojave:         "69a0a72326ffa8622569865a8121253e59c071d7d4e04b7a714d613074bd4724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf871502a89345ab82d466d2d99d1e727618273af9c23713da1f2c5eb4a925a"
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
