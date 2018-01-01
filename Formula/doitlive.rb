class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b1/5d/4a5784409ff94900898ff671df2a32bf19469114eb8006286fda3fc7e8d5/doitlive-3.0.3.tar.gz"
  sha256 "d219d4d198acd74fab066e466b2c402a491afdddbeeb40d51b2b9781143321a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "eff7506bb16d20d86cbf59f2148eb2b462dcbbeacb882b21aa4dae9823bdb16d" => :high_sierra
    sha256 "20330ac92368bca03cc9b13732599ae1e81de2120aff978a1f5d1045caea91b6" => :sierra
    sha256 "574b15c2cbdbaaefe888871397fc3954601f8a1992f4321921e93965bebaad2a" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
