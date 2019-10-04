class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.4.2.tar.gz"
  sha256 "2d6382b94af59dcaa44dd546252807e0364d1b61f169584829ebbf82458e7078"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b4ea171ba30e325769cda03d08c1ea4056eed61eba581f7c5a5fd0d67a918b" => :mojave
    sha256 "b69840e94068b6017eb8744127e2af1b7265d55402ae4d33bdcab7a48937d700" => :high_sierra
    sha256 "970aa58cf62aa58cd7c33f7f3d80e60648a3c0cd1feaf90723c9e5f95b38add2" => :sierra
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
