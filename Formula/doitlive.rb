class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/75/68/44b16599a252364964bebf1f1f59f03e9d3a1fcd9049dc877b3b9682bafa/doitlive-3.0.0.tar.gz"
  sha256 "0e7ae2f1bb1ccb630ff7e0c12cf74d92e126dfe3e63dfecb3ac9992d85084127"

  bottle do
    cellar :any_skip_relocation
    sha256 "92d2920c2872b7074284619a7e0effce74375f50ca27b8fa83031d61406509d9" => :high_sierra
    sha256 "92d2920c2872b7074284619a7e0effce74375f50ca27b8fa83031d61406509d9" => :sierra
    sha256 "e073d738773021f242e10ccf85c08b511160c7329368f70cbdd074a5591db033" => :el_capitan
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
