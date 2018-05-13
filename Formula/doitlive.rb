class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c2/bf/f6969c727748ee1cc1db91fec5f8d41a4a48080d50a4c7138f5616ef5f73/doitlive-4.0.0.tar.gz"
  sha256 "5fe6aaed9efa380000378a90de91221292e3089d50067b169ce8b6b06a2b1723"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d0c3e124bebc24302100e16c0862552ee19fe1067697962592fbcbe7038646e" => :high_sierra
    sha256 "616e6cafaa221d5145504828acd5c738b51ab0888ce3758a8b43c1d7725e6b59" => :sierra
    sha256 "f585c8c0132cda0a413795e035cc2610b97c84848921d52636075d863aafef49" => :el_capitan
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
