class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v1.0.1.tar.gz"
  sha256 "3271f986ff7c4732cfd390383078bfce68c46f9ad74f1804c1b0fc6283b13f7e"
  license "MIT"
  revision 3

  bottle do
    cellar :any_skip_relocation
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
