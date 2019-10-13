class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e5/d9/4ce969d98f521c253ec3b15a0c759104a01061ac90fb9d8636b015bcb4ea/doitlive-4.3.0.tar.gz"
  sha256 "4cb1030e082d8649f10a61d599d3ff3bcad7f775e08f0e68ee06882e06d0190f"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "6ca5a1e71764df35bfe2461d384d1dbd14700a26f7adbe453b7f5a7f801c5f2c" => :catalina
    sha256 "63f336acd1db380b8de5905c777594b7a3cfff6095306ab8aac37a328695e003" => :mojave
    sha256 "3c0fd635d2fdcc4cfd124b976a4724b14c2a9b71a143e60c634028655ab4b8ad" => :high_sierra
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
