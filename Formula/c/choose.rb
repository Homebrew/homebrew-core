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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5c4fa56df4043797b8afd5d16f09ba833cb31c6623311e93f666cd658128d84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591ec66da1ed275c857cf18501b239665db4b24e8e75a31ccd436a753ca2f4bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d70433ad746562e57937e4420e86c2fa8e4bb725b7a795fe96f7025ad8f9cc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdec81b49dfbe6079c974a10fd3d9c38a88ecd5dee80c17e40088190e0c39bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "faae656f20149cf61694f480cf8768faf1980fbd615685430f55b2840bbeb32f"
    sha256 cellar: :any_skip_relocation, monterey:       "68976e471d2940156eacd0f781882efdabe06355b4ef93fd1a01726a8a707014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d41eb1ad4084eab5d86a808d208009b196ead914a9ed5e497f06b04eb7071a8"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  conflicts_with "choose-gui", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/5f/cf/2f01d2231e7fb52bd8190954b6165c89baa17e713c690bdb2dfea1dcd25d/urwid-2.2.2.tar.gz"
    sha256 "5f83b241c1cbf3ec6c4b8c6b908127e0c9ad7481c5d3145639524157fc4e1744"
  end

  def install
    python3 = "python3.12"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resource("urwid").stage do
      system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    end

    bin.install "choose"
    rewrite_shebang detected_python_shebang, bin/"choose"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_predicate bin/"choose", :executable?

    # [Errno 6] No such device or address: '/dev/tty'
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "homebrew-test", pipe_output("#{bin}/choose", "homebrew-test\n").strip
  end
end
