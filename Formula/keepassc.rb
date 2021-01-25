class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 3

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8ba0332d53b90b3922beae741ea4ef144610c633a5852050c60d7876a158c1c3" => :big_sur
    sha256 "1fda05aa9860777fc35146d01c2828b50ea58e297301b6403ffe49a10538fd35" => :arm64_big_sur
    sha256 "71632bb4ea2f91ca573ad5b52ddb233725b2c99b55866d743dda638e69b0c712" => :catalina
    sha256 "b2771b8b9ff6592959e6cde59e6f3f7fd30ad3380f8b2e84911179f1fb0bc3d3" => :mojave
  end

  depends_on "python@3.9"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/90/f4a934bffae029e16fb33f3bd87014a0a18b4bec591249c4fc01a18d3ab6/pycryptodomex-3.9.9.tar.gz"
    sha256 "7b5b7c5896f8172ea0beb283f7f9428e0ab88ec248ce0a5b8c98d73e26267d51"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{pyver}/site-packages"
    install_args = %W[setup.py install --prefix=#{libexec}]

    resource("pycryptodomex").stage do
      system "python3", *install_args, "--single-version-externally-managed", "--record=installed.txt"
    end

    resource("kppy").stage do
      system "python3", *install_args
    end

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc", "--help"
  end
end
