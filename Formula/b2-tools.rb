class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.3.6.tar.gz"
  sha256 "077d5e9b186d4cb0be1fcbeb3b80e1788d8b941b0fcfbf2c7386b8c6a653740c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "df2845790b43d3b514adbcb051f56fe2c41c84658a694969f8c28d32495274dc" => :mojave
    sha256 "8e50af9ea9bcf1824687598a985f9ef203d13d06e23e31def61fe54b88f263c1" => :high_sierra
    sha256 "eb55c4fc29f5e219ad2ab6336c94407ab936a64206535108ba9e96044820634e" => :sierra
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
