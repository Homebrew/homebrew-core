class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.7.2.tar.gz"
  sha256 "7e284cbf0ddc3ae102df03ada91bd4fcfa28e1452a26fe19b136f681e9321e8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "37d50653a0f7b10b3aa13a427995d8f95ab4ab55c0f50c2d108fc20948de2f84" => :sierra
    sha256 "41152cec5a722de0138b554c95302373be5456039bc5062cc05b03282a1286aa" => :el_capitan
    sha256 "b81621e8b5db2f570db1be65c8c399e7e801477a8039113759b3df631c12766f" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "boost-build", :because => "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "b2"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "bad_auth_token", shell_output(cmd, 1)
  end
end
