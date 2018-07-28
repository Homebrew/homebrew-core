class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.3.2.tar.gz"
  sha256 "55cfd021ddc484c0b7252c02c208bc455a9cb20b32fd8401a23b9b62858f3bfb"

  bottle do
    cellar :any_skip_relocation
    sha256 "06e656b0942c203fe07009457d4d78a37b8c29d55dbd9678c6e8366c5477bb47" => :high_sierra
    sha256 "b9e0764f69119e3f1fbbf6ec371828a2afb94dfbbec2587d8e5877f17e768c77" => :sierra
    sha256 "5bc08b320850a7fa47ec9ff2ea9c11c6ae95cf303d5fe164f334141a5790787b" => :el_capitan
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
