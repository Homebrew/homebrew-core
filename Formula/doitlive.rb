class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/22/3e/58dd3cfb662f4729fb45ecc16fc0dbbfc8e8ef51600f174938c2a8b26c62/doitlive-4.1.0.tar.gz"
  sha256 "9f138d4100a5f83e85bbc08a0b26beff2368fbb50a511cb17fe03765b6ad7b7e"

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
