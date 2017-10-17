class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/49/71/6d566ac6b80402c81729f8347f643b01723e81f3dfc7fb94027231b9d292/doitlive-3.0.1.tar.gz"
  sha256 "b70411f7af1041fc58f25a881e44d66ed7c481a7a8ef6f2bb914d76b012c3046"

  bottle do
    cellar :any_skip_relocation
    sha256 "213b3e8ecdfb8d01f207268dd2f4fc762dd6d704e56f04584ba943b628c47fbc" => :high_sierra
    sha256 "213b3e8ecdfb8d01f207268dd2f4fc762dd6d704e56f04584ba943b628c47fbc" => :sierra
    sha256 "e863f6b672998081d3f4adb2e537d8e0ff081eeaa189efdbdf48996a8a8f237e" => :el_capitan
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
