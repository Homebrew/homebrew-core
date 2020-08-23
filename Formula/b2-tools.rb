class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v2.0.2.tar.gz"
  sha256 "1ac04158c73fa40734e8f206757aced0b1668c8f3433975361fa9d100ea85e68"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "44a0e9dd53f7711359859cf75fcadfd741cb15f413929589923770a7c5094358" => :catalina
    sha256 "6153a57ec789a18a9566d692213d814199b9239019f63a3edcb5fe8ccaa05a1d" => :mojave
    sha256 "50f86e78975ab3401e41ddcc6259e94eced3782df36c978b4b4ef7c169fc83dc" => :high_sierra
  end

  depends_on "python@3.8"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
