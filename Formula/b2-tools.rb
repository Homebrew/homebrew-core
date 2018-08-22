class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.3.6.tar.gz"
  sha256 "077d5e9b186d4cb0be1fcbeb3b80e1788d8b941b0fcfbf2c7386b8c6a653740c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b17d1d2aa1671dcbf66276656e9d5f53bb5854931a3e111c60c4d8975491a47" => :high_sierra
    sha256 "1defd127e8d8aee3ee51a6c2d53409b1e29ba8c83dfef133d557c08f9935daa7" => :sierra
    sha256 "3501141422e516c220615b4d30770cce7e65da9b6dcd6c55ea83ac183724714a" => :el_capitan
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
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
