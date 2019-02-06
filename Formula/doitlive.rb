class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/8d/e1cabf1075b44ab3708314b2abdfec660116cd8d5680ad5f9c88709eec7a/doitlive-4.2.1.tar.gz"
  sha256 "46149d44c3327010f35f7957813c3f7be6c7048f609b57d5a5b94100d1c9ce69"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8114d8a94ff27a6b3a6e31fa648c937939757813ab3320ded80e22e571c0d67a" => :mojave
    sha256 "bb3c0d97bcd5354e2f2beac935ac108f1acd6795c26fcb5bbae9ded28785b91b" => :high_sierra
    sha256 "400dfb6ed43ada478a3bcc481e033ed374f4d7f042e122eb6925de3ba8d796f8" => :sierra
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
