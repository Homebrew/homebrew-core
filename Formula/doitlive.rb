class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/8d/e1cabf1075b44ab3708314b2abdfec660116cd8d5680ad5f9c88709eec7a/doitlive-4.2.1.tar.gz"
  sha256 "46149d44c3327010f35f7957813c3f7be6c7048f609b57d5a5b94100d1c9ce69"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cae3c0f2067da2f61ddc31db77b8a779079c040874955b56bbb4a16dede1ec71" => :mojave
    sha256 "c2c780a75165c600ee06b29ec411fb10770b3ec2b9d2fbf2e15d8e2df8a5289d" => :high_sierra
    sha256 "6c0950dd425757f66cf32d999e8643412f5f4dd75c78168b477a0e3b7c14fe55" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    output = Utils.popen_read("SHELL=bash #{libexec}/bin/doitlive completion")
    (bash_completion/"doitlive").write output

    output = Utils.popen_read("SHELL=zsh #{libexec}/bin/doitlive completion")
    (zsh_completion/"_doitlive").write output
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
