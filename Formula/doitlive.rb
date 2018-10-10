class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/67/21/d97f70d6afb56b146175ee4af92ff61ee4ab98a75c36a09b4e4a83c70411/doitlive-4.0.1.tar.gz"
  sha256 "ec1a31b203c9b274fe6f978f4560f82e9ce22d965157172e1b5114ffd99496c5"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5a125c40d3df2b3a2685309c2d7605074dce09128b94d408d4e4bb712c974bce" => :mojave
    sha256 "270d0602c586747c3f8c5351bf5d1efb5d91621c3c33e158e6e6ce1371117c74" => :high_sierra
    sha256 "1352be0bf6405db28892ac75e358e16c3f04f7373895a16bbd044233310774fe" => :sierra
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
