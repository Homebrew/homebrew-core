class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/99/d9/15bfe9dc11f2910b7483693b0bab16a382e5ad16cee657ff8133b7cae56d/liquidctl-1.13.0.tar.gz"
  sha256 "ee17241689c0bf3de43cf4d97822e344f5b57513d16dd160e37fa0e389a158c7"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "979321cdc22895d36f1e99f0b616ce095cbc476e80f29a760a30d36d613c8891"
    sha256 cellar: :any,                 arm64_ventura:  "0a83c13630af30ec52110168f24eedabe8946501ece728633d633e795113c7b8"
    sha256 cellar: :any,                 arm64_monterey: "865ffd2cdd6ec5616d7a20171e98034ff31dd9e0a0d037173629a80420dfe8f4"
    sha256 cellar: :any,                 sonoma:         "349dce496c01ec5321b4e62841c29b6b766b92e7712fbe3fc0d7303fb14e9352"
    sha256 cellar: :any,                 ventura:        "d9d7e17d6d44d73a3c1dbdd1fb3d6ba6d7dcb3650315c08b66691d93e14579ff"
    sha256 cellar: :any,                 monterey:       "fa04016f8f34d03141ca59c3e58c8a20de84a21d76f2461f5b7578e21f75b8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90daad2f98669c64866ed4d1eccc1fe5611f766fd4491111691bec3844b1923"
  end

  depends_on "python-setuptools" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.12"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/95/0e/c106800c94219ec3e6b483210e91623117bfafcf1decaff3c422e18af349/hidapi-0.14.0.tar.gz"
    sha256 "a7cb029286ced5426a381286526d9501846409701a29c2538615c3d1a612b8be"

    # patch to build with Cython 3+, remove in next release
    patch do
      url "https://github.com/trezor/cython-hidapi/commit/749da6931f57c4c30596de678125648ccfd6e1cd.patch?full_index=1"
      sha256 "e3d70eb9850c7be0fdb0c31bf575b33be5c5848def904760a6ca9f4c3824f000"
    end
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)

    resource("hidapi").stage do
      inreplace "setup.py" do |s|
        s.gsub! "/usr/include/libusb-1.0", "#{Formula["libusb"].opt_include}/libusb-1.0"
        s.gsub! "/usr/include/hidapi", "#{Formula["hidapi"].opt_include}/hidapi"
      end
      system python3, *Language::Python.setup_install_args(libexec, python3), "--with-system-hidapi"
    end

    venv.pip_install resources.reject { |r| r.name == "hidapi" }
    venv.pip_install_and_link buildpath

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1" if OS.mac?
    man.mkpath
    man8.install man_page

    (lib/"udev/rules.d").install Dir["extra/linux/*.rules"] if OS.linux?
  end

  test do
    shell_output "#{bin}/liquidctl list --verbose --debug"
  end
end
