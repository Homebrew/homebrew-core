class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.0.0.tar.gz"
  sha256 "7d9643474a1554aa858d0e6aa75433bac8b6797fd58d04b959f372b89ee38c6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2a8a03eec57a7936d159620592d39080cbdc644bad8abef8abeff0bf2d3c6a" => :high_sierra
    sha256 "fb4b0631e13cafe26975d6c36fbb9a1602c4c4b40a0ffad0377edb95dbe155c8" => :sierra
    sha256 "14ef28f1f55498c97ffc288bc7d16ec3154d3e1a73bd8e8d423ae75d931cb62b" => :el_capitan
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
