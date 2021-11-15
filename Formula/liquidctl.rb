class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/e4/f5/745cc14e5748de5d5ac3ccc1a0a9ee5e0e73858aafcc863514ce88956c0b/liquidctl-1.7.2.tar.gz"
  sha256 "b2337e0ca3bd36de1cbf581510aacfe23183d7bb176ad0dd43904be213583de3"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b23f4d0d050a0d23265a693a95aa8136e23182d055b29900e6a472bdce0faad"
    sha256 cellar: :any,                 arm64_big_sur:  "f328324cba24b07779199d88ce405d2f6a8a4e023021f71cb8b745b698cd675c"
    sha256 cellar: :any,                 monterey:       "1e162bec371b1719136560651500a019b4c46b13153d4c01e813c1bcedcceb09"
    sha256 cellar: :any,                 big_sur:        "bad09035eeea790c15be5d4f888e5e7d289f2e6d826af9e5e568907275503d70"
    sha256 cellar: :any,                 catalina:       "c20cb061748d4bcc952ed77ab148ca73a4bed576bbe5e1c9b7595eca9a74f8e0"
    sha256 cellar: :any,                 mojave:         "68edf5e0b19b017ab73a4381525ea5cc9b365c4284ea6ea80e00c09cbbdd7299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9def490100759b197a6785a095d322cd9958bbe9ecbe6b09c8da081d7cf7b51"
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
