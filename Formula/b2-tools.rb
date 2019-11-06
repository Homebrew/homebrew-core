class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.4.2.tar.gz"
  sha256 "2d6382b94af59dcaa44dd546252807e0364d1b61f169584829ebbf82458e7078"

  bottle do
    cellar :any_skip_relocation
    sha256 "e21e5a9daf848f8a36850cad7d18073c8b8af9db6bf2e6860549b6e7123e2b00" => :catalina
    sha256 "6d034a4b3ef822dd53b09a17ff0e924d6ad130cc6b376287425cc0300d425bc6" => :mojave
    sha256 "450cd0e09c64458f5af99414f523f56b93275c5efa6ed2c0a6a18420917d2a31" => :high_sierra
  end

  depends_on "python"

  conflicts_with "boost-build", :because => "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "b2"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
