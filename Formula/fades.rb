class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/cd/b0/381b14139b36dcbd317349ce7c2bd2e2a66bfc772d13e568d71f3d98d977/fades-9.0.tar.gz"
  sha256 "77192b76efbd08dfabce65fe6012805a2383ec1b893c12091efe35fbfd9677f6"
  license "GPL-3.0"
  revision 1
  head "https://github.com/PyAr/fades.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "21973bd9531e3c6af4359e51ac9e31982bfbdf024843b02226168910a39aabd2" => :big_sur
    sha256 "7bc2eb2954b2600729559c9f2f58b89b00ad958499aeddaeec1533160907831b" => :arm64_big_sur
    sha256 "78532c867a5ab35381edeb565f094fff1d2d269c169f903e10bde65a2ee2b3c7" => :catalina
    sha256 "bc2264df647adc84ef4f5321258ee9030da3269a66d4f50ed5faf0cc3185bd83" => :mojave
    sha256 "bdf1c47688725b9335adaca1dae977fba9aa534d44f4c65b4a1a684d6fc7930e" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system "#{bin}/fades", testpath/"test.py"
  end
end
