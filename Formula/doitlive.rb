class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8c/41/b08e2883c256d52f63f00f622cf8a33d3bf36bb5714af337e67476f8b3fe/doitlive-2.8.0.tar.gz"
  sha256 "0f9a17955ea0877388610cefdc32bb260b51f81d56983fa60ebbf1b084137cca"

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
