class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/7f/ea/23d43e8746b88a80ca0bb8854414afd9ec4ce29a7a0b7ea147bdb9f4ff96/doitlive-2.7.0.tar.gz"
  sha256 "fc4b3d94577a6633b82338017acad1485c1624b7e135cc4c4f173dc427f1ba05"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5041e5134744e17de19ff0affd1fe71c2fb42408ee9eb0973f0549e1a45a1e0" => :sierra
    sha256 "54e6f6d771d1880d8c4e364057ab2392be02af073918c719590c154cf055a690" => :el_capitan
    sha256 "54e6f6d771d1880d8c4e364057ab2392be02af073918c719590c154cf055a690" => :yosemite
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
