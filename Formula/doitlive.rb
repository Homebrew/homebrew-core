class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/8d/e1cabf1075b44ab3708314b2abdfec660116cd8d5680ad5f9c88709eec7a/doitlive-4.2.1.tar.gz"
  sha256 "46149d44c3327010f35f7957813c3f7be6c7048f609b57d5a5b94100d1c9ce69"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "808da033ebffe76926139e44a3c69434403f3873576e91b701e5fdc87726f4c2" => :mojave
    sha256 "e2837619960de9f94dfd4b39b5c7924da768dc8b8bde917b5f0e405ac5914d43" => :high_sierra
    sha256 "4e1809008663b4f89187c339d3e0a79c81e025dd884c483fef79da5857e79377" => :sierra
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
