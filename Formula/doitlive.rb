class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/8d/e1cabf1075b44ab3708314b2abdfec660116cd8d5680ad5f9c88709eec7a/doitlive-4.2.1.tar.gz"
  sha256 "46149d44c3327010f35f7957813c3f7be6c7048f609b57d5a5b94100d1c9ce69"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "ce2dfad4d9a18daa5144de9b9463fec2ba258971f55b4bc019702f00886beab1" => :mojave
    sha256 "a1972aab087a2ce19517b1d2f359af56f5e8ff28b9febba56bfa6c3843c070aa" => :high_sierra
    sha256 "aa7a2349ebf41826a3fc89ad663e3586a94c4691b734d3b56510c24290337014" => :sierra
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
