class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/a2/8b/c404bce050eba79a996f6901f35445a53c1133b0424b33e58a4ad225bc37/honcho-1.0.1.tar.gz"
  sha256 "c189402ad2e337777283c6a12d0f4f61dc6dd20c254c9a3a4af5087fc66cea6e"
  license "MIT"
  revision 3
  head "https://github.com/nickstenning/honcho.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3b71dbaf78c89d80cb6ad81942556f67ea90ad152c919f65a986ed7a7b90d2ad" => :big_sur
    sha256 "042378b35c51528de85dc5c1999605bfaf561063da18b50bc3665331b9193019" => :catalina
    sha256 "65e4f0673086e6cf37184b82faa1c78c8cf32dc642c9a70caeb8deb16e455f95" => :mojave
    sha256 "39a8cdb134c590156a7ca18d4342933aa19a5163d38ab1caf6f2079d0348b506" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match /talk\.\d+ \| hi/, shell_output("#{bin}/honcho start")
  end
end
