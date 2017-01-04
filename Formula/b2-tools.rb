class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.7.0.tar.gz"
  sha256 "99800646e103cc6dd56a361508de3c53e026b6ca93719900183189078906b0a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc12ce92c4395e0eaad7a5838d0e751ba032bc13b2798590208016b421cb34f" => :sierra
    sha256 "32ecef3456e90b5aa3c178d32a959290190df17260d8a0babe36f31693307fe5" => :el_capitan
    sha256 "2dcb48ec7e164ed72fed8f53f7437118c60320c74898981b1a6e2397bd6e1dc9" => :yosemite
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
