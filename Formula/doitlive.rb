class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/22/3e/58dd3cfb662f4729fb45ecc16fc0dbbfc8e8ef51600f174938c2a8b26c62/doitlive-4.1.0.tar.gz"
  sha256 "9f138d4100a5f83e85bbc08a0b26beff2368fbb50a511cb17fe03765b6ad7b7e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e8af636c39be8cfe776de90bf5013d101db3a5050572027a11b83e31ae6c9acd" => :mojave
    sha256 "20be070bf18466903939e362fc8fed37d1c2ceb44c9516c68a46dc5639142075" => :high_sierra
    sha256 "66bec8e757ccbffba6c102b870bdc984d3bc3763129985dfbd95603f11e5f096" => :sierra
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
