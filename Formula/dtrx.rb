class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/25/cb/1ef093d762f4d5963e9e571daec239acc5f4971eb9daeda77b131d7cf39f/dtrx-8.3.1.tar.gz"
  sha256 "5587258e762074d5395a6824fd7968ca4f4a1dc481f4852fb84d14e7624433fb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ca7a9b060a281c5e3483bff43d8311291530a28756a4ea2d4c6c5621839d58c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da738e87e28fcd982398d9e6692b48f4f2cefc559c36c398263247d159441b79"
    sha256 cellar: :any_skip_relocation, monterey:       "84cd22f24bbb11aa0dbfcb4861878e6c3c4dbf1e61d0e8f04271b6cf40be1f9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "94b86cd5d6573b013ba01c25e621b20001cf1fb7059f62a6e923896003281909"
    sha256 cellar: :any_skip_relocation, catalina:       "c3f597698b93f8a454b6b36d5dca0bf69f8fa32477a893a3f2125014f681cccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "922c1a0c5b010798328531ba30313d2f461d0458abf7b7d11fa0d365dc86b6fc"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.10"
  depends_on "xz"
  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system "#{bin}/dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
