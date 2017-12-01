class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.1.0.tar.gz"
  sha256 "fae0dd48a2b6ab38cb142b91d7907a66144659d599bdfbf3c8995788ed29313b"

  bottle do
    cellar :any_skip_relocation
    sha256 "94ddeb7d56a0c164120429cf819001d950cce3ec7996f8057a7a1e20bf33f99b" => :high_sierra
    sha256 "6210536251b3a1a4066a7b2cd0bc3e7a0b0173525a792da2e4003b917799b4d7" => :sierra
    sha256 "a15207e3615b4865877c8d48976708c926e0d095303b4c95a49b196e14acda04" => :el_capitan
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
