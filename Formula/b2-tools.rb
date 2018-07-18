class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.2.0.tar.gz"
  sha256 "7f6269257045d571ace6738a3b30bc395bb83f8721b44e06088485f5d2a1ca6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "14aff17debc942de445e1bed7412f535056ef7fb13bad841c4b80a328fd9bb90" => :high_sierra
    sha256 "387a86e2ab8693340550a1131a02184b11a357c013bab086668c617d445d9212" => :sierra
    sha256 "8e3e9bde7540a41fc5e0a4fe6a4d6f154ff7eef1e07940d14c8cd35ee6a7004d" => :el_capitan
  end

  depends_on "python@2"

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
