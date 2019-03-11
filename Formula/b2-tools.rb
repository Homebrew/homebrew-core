class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.3.8.tar.gz"
  sha256 "2ed276b9eb6796470280e4be27ef96018e338a87efa9cd70115ffbb6b030a6ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "583fdcbde3f7e4aa636a21cd1dc1b3620b24f5c32898d5b9e50c39d345797873" => :mojave
    sha256 "6ef673a1922b3b9e516f13b167000baba348ae303f28ae659cfef2816866c660" => :high_sierra
    sha256 "912e96dfd2c7701e2390380a68e7008d33d26e82877fbcc062f5dc25e0687fc9" => :sierra
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
