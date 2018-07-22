class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/67/21/d97f70d6afb56b146175ee4af92ff61ee4ab98a75c36a09b4e4a83c70411/doitlive-4.0.1.tar.gz"
  sha256 "ec1a31b203c9b274fe6f978f4560f82e9ce22d965157172e1b5114ffd99496c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6f9718db7981f84e3188bfaf9d8b1725b3d8f070cf2bb69a4a66aae4e1c33e5" => :high_sierra
    sha256 "73a77f790b0365fdf858f67685591ab2d7fac37a28076b3a755baca7e357f94c" => :sierra
    sha256 "66326431fffbc6858f121521297581c2e944b901f798bba6f66774bce947cc20" => :el_capitan
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
