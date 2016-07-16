class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v0.7.1.tar.gz"
  sha256 "6d838c77ffda1e59507542ac3aa062c2865e506aa7ead6814780c2f2e39cf959"

  bottle do
    cellar :any_skip_relocation
    sha256 "6469c1a7f8136472fd3222a392b7f14e2bb525e9818fb50e6563d4ba11153627" => :el_capitan
    sha256 "67b976fb9de691ebd2424475a83688b20f2cfd630ad8080f1e96ff6954971964" => :yosemite
    sha256 "3a52f9b3e325e2509362f00c4d42a718a295fed8ae13dcc53e57a1408f923032" => :mavericks
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
    assert_match /talk\.\d+ \| \e\[0mhi/, shell_output("#{bin}/honcho start")
  end
end
