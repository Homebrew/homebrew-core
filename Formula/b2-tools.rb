class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.3.2.tar.gz"
  sha256 "55cfd021ddc484c0b7252c02c208bc455a9cb20b32fd8401a23b9b62858f3bfb"

  bottle do
    cellar :any_skip_relocation
    sha256 "01517d6b0e7f180d3c7b5690aecc0464331aa3600aa68cdbac80b9b1e45bf7bb" => :high_sierra
    sha256 "53cc59436c1e10ad71ee34f8c01592b46f74ea823f2680309724f9bcb1084596" => :sierra
    sha256 "00c627b7326ad35003e2d614332be1e3de0ef1cd1de0a14a55b12aaaa1bf36c4" => :el_capitan
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
