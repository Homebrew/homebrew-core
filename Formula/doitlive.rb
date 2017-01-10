class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://pypi.python.org/packages/81/79/ef8a1e4d66dacd35dad49eec8304873b7608d5146ef9cf849679b2757739/doitlive-2.6.0.tar.gz"
  sha256 "e3f577f8e0de03cf1431f5bd1482778d149f6061c8167cbe6abfdcc3b9a5a619"

  bottle do
    cellar :any_skip_relocation
    sha256 "002fdcd45d96e3c6974230f59efdf5194f5e3dda41cac5add23b7376b4f2c575" => :sierra
    sha256 "93ef969beb5380908c77239573b622e82ee0863d8222c22ae3189fd3d54c3ee2" => :el_capitan
    sha256 "93ef969beb5380908c77239573b622e82ee0863d8222c22ae3189fd3d54c3ee2" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
