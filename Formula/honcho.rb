class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v1.0.1.tar.gz"
  sha256 "3271f986ff7c4732cfd390383078bfce68c46f9ad74f1804c1b0fc6283b13f7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5b5d510c350dbc1780bddb82760603ebcacbb2dd382955f2a9f4b781e02005" => :sierra
    sha256 "0af8a184c2790eacbd3e0b43e90a55fc15baf17ba1f4963c5b05f78b7785737c" => :el_capitan
    sha256 "0af8a184c2790eacbd3e0b43e90a55fc15baf17ba1f4963c5b05f78b7785737c" => :yosemite
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match /talk\.\d+ \| hi/, shell_output("#{bin}/honcho start")
  end
end
