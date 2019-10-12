class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e5/d9/4ce969d98f521c253ec3b15a0c759104a01061ac90fb9d8636b015bcb4ea/doitlive-4.3.0.tar.gz"
  sha256 "4cb1030e082d8649f10a61d599d3ff3bcad7f775e08f0e68ee06882e06d0190f"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "cf4f54b4fe347da32d65c53e61d9bdff5f31c9f8a35c37097ce662d9f44f3433" => :catalina
    sha256 "235dcd551986f6fcaa2e9bc0bcbddfa631219cbf1b9ed0bdf692087e48ee20d2" => :mojave
    sha256 "d0e4f3e10a4c12cbb9f01f67858b53317ed52a91370d3df3a27ac0bf688280d7" => :high_sierra
    sha256 "59c58d804d10fa88962ab485ecff1d058f68359ee7687bd029318928eeebf8a8" => :sierra
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
