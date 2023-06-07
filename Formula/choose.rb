class Choose < Formula
  include Language::Python::Shebang

  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 4
  head "https://github.com/geier/choose.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60edac2ca7068597d568e29de1e96d75f9be09c8b57b0fb5b440cd257d2bdd23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f4326c503b639e781160a68ba76829d7754c7927f4b2d69a63740015f948217"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18e369ca2b875807bb7478bd6be4ef94d9ec5634f43f0d5d1a0b01abcfc8955f"
    sha256 cellar: :any_skip_relocation, ventura:        "8e53d191a07c9951863aadc6e7feec473a93673c06c552b6e6e431aa24c355bd"
    sha256 cellar: :any_skip_relocation, monterey:       "fa636248938e6bc14e77f62bd8ae189d1e1a9ab07db213518c8147ff3a626a85"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e8e3a3540c95f09c2b68658a59e6da6543b23a97393fc49b2f178d4c00f4f9d"
    sha256 cellar: :any_skip_relocation, catalina:       "91a731c9e1a3d4d8ce715260ed74513d63858c2777bacf40128ac0d5bd6d0b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b082f85bccbb84100ca7c3063bdd13a74d4fc4e16762be36ab38d41afc7659e"
  end

  depends_on "python@3.11"

  conflicts_with "choose-gui", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resource("urwid").stage do
      system python3, *Language::Python.setup_install_args(libexec, python3)
    end

    bin.install "choose"
    rewrite_shebang detected_python_shebang, bin/"choose"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_predicate bin/"choose", :executable?

    # [Errno 6] No such device or address: '/dev/tty'
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "homebrew-test", pipe_output(bin/"choose", "homebrew-test\n").strip
  end
end
