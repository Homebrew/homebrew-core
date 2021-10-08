class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/e4/f5/745cc14e5748de5d5ac3ccc1a0a9ee5e0e73858aafcc863514ce88956c0b/liquidctl-1.7.2.tar.gz"
  sha256 "b2337e0ca3bd36de1cbf581510aacfe23183d7bb176ad0dd43904be213583de3"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "41155e9da1a11de698cbf51084b667ea4512d81686de7dcfbfac7187e3ab2518"
    sha256 cellar: :any,                 big_sur:       "e9cc719dcc5f8d3ebaaafd336f25f65a2422241c0c7dff62c504e9ec0a5973ca"
    sha256 cellar: :any,                 catalina:      "2d2f94f10f294ff5a7d88dc421e93de375570a4d433fe5567142904a6bd62b73"
    sha256 cellar: :any,                 mojave:        "6c5dcbfeb216269feb853a4b5f00108051f760e46fe4a61e4b6e55637599fcdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25cbf3bcada320d6481a7683bbb042b0e32e838d5496045ad92b9101846d21fa"
  end

  depends_on "hidapi"
  depends_on "libusb"
  depends_on "python@3.10"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/c2/42/f7a7d8eaa3420fcfc7b85c423c0800b0f2eb2241c780705f0952eafd0171/colorlog-6.5.0.tar.gz"
    sha256 "cf62a8e389d5660d0d22be17937b25b9abef9497ddc940197d1773aa1f604339"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/99/9b/5c41756461308a5b2d8dcbcd6eaa2f1c1bc60f0a6aa743b58cab756a92e1/hidapi-0.10.1.tar.gz"
    sha256 "a1170b18050bc57fae3840a51084e8252fd319c0fc6043d68c8501deb0e25846"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    venv = virtualenv_create(libexec, "python3")

    resource("hidapi").stage do
      inreplace "setup.py" do |s|
        s.gsub! "/usr/include/libusb-1.0", "#{Formula["libusb"].opt_include}/libusb-1.0"
        s.gsub! "/usr/include/hidapi", "#{Formula["hidapi"].opt_include}/hidapi"
      end
      system libexec/"bin/python3", *Language::Python.setup_install_args(libexec), "--with-system-hidapi"
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
