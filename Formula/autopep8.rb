class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ca/d3/bb1c5781415b2a4f7d48bcd4c62e735d5ebf40d4f8c325d654870bedb7a6/autopep8-1.5.1.tar.gz"
  sha256 "cc6be1dfd46f2c7fa00e84a357f1a269683985b09eaffb47654ed551194399eb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2f1564bd116ad939ed8fd2a497865c416fbfa939cf94242cec47f1dd15cd0a06" => :catalina
    sha256 "7b3e36fcfef4a1475727845753b1f2a512fc1b982527cb5d0dba08b7fdd007df" => :mojave
    sha256 "9178c1e4b633eaad87163a18b55a7818969b3464569d6bb87ceba0e2d1fbb8b4" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
