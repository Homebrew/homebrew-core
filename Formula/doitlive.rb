class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/75/68/44b16599a252364964bebf1f1f59f03e9d3a1fcd9049dc877b3b9682bafa/doitlive-3.0.0.tar.gz"
  sha256 "0e7ae2f1bb1ccb630ff7e0c12cf74d92e126dfe3e63dfecb3ac9992d85084127"

  bottle do
    cellar :any_skip_relocation
    sha256 "ced8f310f83d06ccda2efa39311fa8b6092a5e8584aefc4f0e4575908a60287c" => :high_sierra
    sha256 "ced8f310f83d06ccda2efa39311fa8b6092a5e8584aefc4f0e4575908a60287c" => :sierra
    sha256 "4420d12d87d42f46c11520f387941a21f2c631de0737466c665bb7c5bcebb856" => :el_capitan
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
