class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"

  url "https://github.com/trek10inc/awsume/archive/4.0.0.tar.gz"
  sha256 "8cc7d466beef1c32b3397ed62cba22f7a309ab1650317cef6873cf019be7d25e"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7627407c05644c59ee3ba36d592e92c8dcec7d663c5eb53ddd52062fa0c61c3" => :catalina
    sha256 "a26e73a7ad4e464d9dd2bdd027dee7a729f6f28a36800fc22701b1dd729e29d1" => :mojave
    sha256 "0eba67450540e7d925d166a50dc2051fc4d867cba692a3f2a8d6a7c612065cf5" => :high_sierra
  end

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
    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))
  end
end
