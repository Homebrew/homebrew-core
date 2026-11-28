class PyenvVirtualenvwrapper < Formula
  desc "Alternative to pyenv for managing virtualenvs"
  homepage "https://github.com/pyenv/pyenv-virtualenvwrapper"
  url "https://github.com/pyenv/pyenv-virtualenvwrapper/archive/refs/tags/v20140609.tar.gz"
  sha256 "c1c812c4954394c58628952654ba745c4fb814d045adc076f7fb9e310bed03bf"
  license "MIT"
  head "https://github.com/pyenv/pyenv-virtualenvwrapper.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "191f4ce6c1faf32617d15f7770b8536005f745783f1515f10101e3492bd3c79f"
    sha256 cellar: :any_skip_relocation, all: "0aeb3455529d63f4cd1ca55acb525e4f38e1fc7b8dca986302f475bc8596a650"
  end

  depends_on "pyenv"

  deny_network_access!

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvwrapper")
  end
end
