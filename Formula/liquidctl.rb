class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/cc/0d/0d014ab062eb831c53d745bd61836f9247a7e9695d21aea40276f2aa3c17/liquidctl-1.9.1.tar.gz"
  sha256 "b4467e842d9a6adc804317a991354db041417f4f7dcf7d76799f2b1593ed1276"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ce7356ec6a382dbd114dedf91772569c0c332526f6ba86c704b1d34941a4166"
    sha256 cellar: :any,                 arm64_big_sur:  "8695ab4af1bc8486ed693cdc5741ac95f4179e93d1cc61ac6eb64323683046b1"
    sha256 cellar: :any,                 monterey:       "5adc905e76d808b6d66b08674d83b9208cadf5207a84e978a1fcfb5e1fc014bb"
    sha256 cellar: :any,                 big_sur:        "bac635e8d1844f4f6ab7ac575dd8178801322128eec9083200153e7301715285"
    sha256 cellar: :any,                 catalina:       "8271e9134cf6af394ba98427fa0fb315d704e24e7b3a257d28fabe6ec5f5d98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "353ad933b9d69bc2702a59b796d18f90d60f5f8bcf8da96085bc6a83a2843265"
  end

  depends_on "hidapi"
  depends_on "libusb"
  depends_on "python@3.10"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/c0/36/1ae403d51262337de39bb026b2ccbe588668273c3361f5d49f0e2094f318/hidapi-0.11.2.tar.gz"
    sha256 "c984b7ec2fc2ea987cd44cf06947e55572498ed2d43c64890b4ab58b29af72bc"
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
