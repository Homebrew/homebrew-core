class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.3.4.tar.gz"
  sha256 "3e224cb19b16ffd293048b73ac59a2c3d99b8ab0059469ce36ce5f290dfabe69"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d3857d852af6e8726e7a12b26507b97426eba4beb44137d4db684b9b9df6ea7" => :high_sierra
    sha256 "d694bd624e00f7aa688a7666b744343b2deb346474b6b33eb331897e9501f6f0" => :sierra
    sha256 "e5ba3b1ac9882d324684850cf8157ff065588d01f2b03b36b3a97c99247731f1" => :el_capitan
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
