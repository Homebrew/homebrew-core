class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v1.0.1.tar.gz"
  sha256 "3271f986ff7c4732cfd390383078bfce68c46f9ad74f1804c1b0fc6283b13f7e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8bc883894e8b6f07ab526e862500f40b7c47101a0f0ee66540cc5451b00b807e" => :mojave
    sha256 "41492a0296ea50b9b93f83e11d2b50bf7bc2a1361cf1da82bf61023f04f1e782" => :high_sierra
    sha256 "41492a0296ea50b9b93f83e11d2b50bf7bc2a1361cf1da82bf61023f04f1e782" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match /talk\.\d+ \| hi/, shell_output("#{bin}/honcho start")
  end
end
