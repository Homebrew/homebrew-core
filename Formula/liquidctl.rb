class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/0c/ed/97969c17f4d6b31604a9b6fba1c20c8a6e9f6fea3f2ee79f4dd11d70e7d4/liquidctl-1.12.1.tar.gz"
  sha256 "3f98b8400c9cd3e47925cafbe34b9d7a51705bf85ce1ec8d95d107a360f6f29e"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c096b3dd686532cc1f709567752530954cd2e4b6a42f0d1af99bda49679ca30"
    sha256 cellar: :any,                 arm64_monterey: "c0ff601e34753233c699a2a189daa6387126fa6b8effd41980076c5b90d369bc"
    sha256 cellar: :any,                 arm64_big_sur:  "ee7c31ad4a77c8c0d760241be4f2f2a7b4bd6fbae876816258a1ef5fc3c1b4e5"
    sha256 cellar: :any,                 ventura:        "ebe0f7c3ce3c694a203bc23c17dc76b21febc2f29370ca7b52f79983f4668abb"
    sha256 cellar: :any,                 monterey:       "273647d88bc026576395220418a21d0ab11b698dab5c4bc76c9ebc62ba413b89"
    sha256 cellar: :any,                 big_sur:        "c8d9396df9d7df04f903a44305ec02bacda3ecf541967dc089eaca744adbd3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c619ad864a8d545b2a002a8cafe9d57fcc4bbc88ece08757a48dd5a8d65075c"
  end

  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.11"

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
    url "https://files.pythonhosted.org/packages/78/0a/d71f35a8dcbe88dab21cd668a62b688ea6dd45872feba45a97efd0452c19/hidapi-0.13.1.tar.gz"
    sha256 "99b18b28ec414ef9b604ddaed08182e486a400486f31ca56f61d537eed1d17cf"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    python3 = "python3.11"
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
