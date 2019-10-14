class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"

  url "https://github.com/trek10inc/awsume/archive/4.0.0.tar.gz"
  sha256 "8cc7d466beef1c32b3397ed62cba22f7a309ab1650317cef6873cf019be7d25e"
  head "https://github.com/trek10inc/awsume.git"

  depends_on "openssl"
  depends_on "python"
  uses_from_macos "sqlite"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awsume"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_includes "4.0.0", shell_output("#{bin}/awsume -v")
    shell_output(File.exist? { File.expand_path("~/.awsume/config.yaml") })
  end
end
