class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/49/71/6d566ac6b80402c81729f8347f643b01723e81f3dfc7fb94027231b9d292/doitlive-3.0.1.tar.gz#md5=47c690eb28b90fcf5ea0634fb9b12711"
  sha256 "b70411f7af1041fc58f25a881e44d66ed7c481a7a8ef6f2bb914d76b012c3046"

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
