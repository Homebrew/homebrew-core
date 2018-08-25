class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://github.com/buildinspace/peru/archive/1.1.4.tar.gz"
  sha256 "aa93ba4d7663f597c05a14dc39cac57ddcdaa70b876c90ebe46bf205240b0784"

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
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
