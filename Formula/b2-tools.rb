class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.0.0.tar.gz"
  sha256 "7d9643474a1554aa858d0e6aa75433bac8b6797fd58d04b959f372b89ee38c6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2245ce290eaa6feae92ccba74eaa5591514ae7fbc97c135497c42717bb3e5b2f" => :high_sierra
    sha256 "c1b069f9fc793f05571eb1d4c073a9cc47593057b9949856dd7216fa48e20e8e" => :sierra
    sha256 "b529efc7f330e93f271e24dea4e98f88173f6a80d632bd7e9283398aebb23a0a" => :el_capitan
    sha256 "00200d38eb87bd8fb91b5c2133791254493d48675b8970f4ff865770cf800225" => :yosemite
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
