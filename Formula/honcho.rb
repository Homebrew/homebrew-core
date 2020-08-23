class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v1.0.1.tar.gz"
  sha256 "3271f986ff7c4732cfd390383078bfce68c46f9ad74f1804c1b0fc6283b13f7e"
  license "MIT"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "986c98221b9bb025b0c8fa8c1f4ca150ee1853488f6060b603c54aa7e02c8be1" => :catalina
    sha256 "986c98221b9bb025b0c8fa8c1f4ca150ee1853488f6060b603c54aa7e02c8be1" => :mojave
    sha256 "986c98221b9bb025b0c8fa8c1f4ca150ee1853488f6060b603c54aa7e02c8be1" => :high_sierra
  end

  depends_on "python@3.8"

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
