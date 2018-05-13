class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c2/bf/f6969c727748ee1cc1db91fec5f8d41a4a48080d50a4c7138f5616ef5f73/doitlive-4.0.0.tar.gz"
  sha256 "5fe6aaed9efa380000378a90de91221292e3089d50067b169ce8b6b06a2b1723"

  bottle do
    cellar :any_skip_relocation
    sha256 "eff7506bb16d20d86cbf59f2148eb2b462dcbbeacb882b21aa4dae9823bdb16d" => :high_sierra
    sha256 "20330ac92368bca03cc9b13732599ae1e81de2120aff978a1f5d1045caea91b6" => :sierra
    sha256 "574b15c2cbdbaaefe888871397fc3954601f8a1992f4321921e93965bebaad2a" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    output = Utils.popen_read("SHELL=bash #{libexec}/bin/doitlive completion")
    (bash_completion/"doitlive").write output

    output = Utils.popen_read("SHELL=zsh #{libexec}/bin/doitlive completion")
    (zsh_completion/"_doitlive").write output
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
