class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v2.0.2.tar.gz"
  sha256 "1ac04158c73fa40734e8f206757aced0b1668c8f3433975361fa9d100ea85e68"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0828a503f620c700dbdc14b1ed8c7c3f3e24d8ec7957d4ddc82096878937dc27" => :catalina
    sha256 "699e4b2c8b59b1e0e8f9a201414999a849d310e74df0b324630f04a49d7fb909" => :mojave
    sha256 "8df0fc81ad83193c54130bce8697f578b9581dbeaf73b736812e5e8aa603290f" => :high_sierra
  end

  depends_on "python@3.9"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
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
