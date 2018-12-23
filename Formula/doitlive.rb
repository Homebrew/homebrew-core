class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/8d/e1cabf1075b44ab3708314b2abdfec660116cd8d5680ad5f9c88709eec7a/doitlive-4.2.1.tar.gz"
  sha256 "46149d44c3327010f35f7957813c3f7be6c7048f609b57d5a5b94100d1c9ce69"

  bottle do
    cellar :any_skip_relocation
    sha256 "c55956dfb1b16b5923b1b9bdbd43462164e7f75847258be5e14623fc2a962e15" => :mojave
    sha256 "b5cfe05b5e8a03ae1cb982b7a431c66292b4b9fff6bd88f75221da1ddfa2eb78" => :high_sierra
    sha256 "36a5f5fc0d2d7fffaf86ffefdea2b3614004350d09138f3a6e48ac522de1dc93" => :sierra
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
