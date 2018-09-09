class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/db/ad9aa0e58bffc4f6f306d40608a7a755777ef283c28dee5a4c6a4dc47cad/peru-1.1.4.tar.gz"
  sha256 "d899e1376009f7f95d220863ea79ca51712cd4bf769fff48973c239bf54e56d4"

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    peru_yaml = <<~PERU
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    PERU
    File.write("peru.yaml", peru_yaml)
    system "#{bin}/peru", "sync"
  end
end
