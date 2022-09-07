class EyeD3 < Formula
  include Language::Python::Virtualenv

  desc "Work with ID3 metadata in .mp3 files"
  homepage "https://eyed3.nicfit.net/"
  url "https://eyed3.nicfit.net/releases/eyeD3-0.9.6.tar.gz"
  mirror "https://files.pythonhosted.org/packages/fb/f2/27b42a10b5668df27ce87aa22407e5115af7fce9b1d68f09a6d26c3874ec/eyeD3-0.9.6.tar.gz"
  sha256 "4b5064ec0fb3999294cca0020d4a27ffe4f29149e8292fdf7b2de9b9cabb7518"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/nicfit/eyeD3.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e439834b1f3942d1318b958cf4363dc68386dcc5930841207d13d56e3bf0be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3bf5857dd54a6b08e2367bfca0d01a23ad251fc4fbbc1479ffb27dca61deb08"
    sha256 cellar: :any_skip_relocation, monterey:       "a815764695f279f4f0402da82ab02d5db6c7acae8678b9f4bc486f2fe8e1d628"
    sha256 cellar: :any_skip_relocation, big_sur:        "884850552176a42baf923bf4c0b1a57144c8ebc6b7b5a9451dbdb1c932995e24"
    sha256 cellar: :any_skip_relocation, catalina:       "0279f0d6ae173bbfc09afbd493e1b2ee6265bda57b312cfd8b7f1f4229ee9e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c511552fe4d3bbed9ef74934bfd5cf2e2cc42d395f38106cf78d70a40ad8f5aa"
  end

  depends_on "python@3.10"

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/40/05/2c1d1405edeec38114abcd404f15a35a41029b89d0514aa8ad11ffcbde81/coverage-5.3.1.tar.gz"
    sha256 "38f16b1317b8dd82df67ed5daa5f5e7c959e46579840d77a67a4ceb9cef0a50b"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/56/86/1a6b76adf5be0e88ebc084beacb80fa3fb0eab68890ed1030ad50ac83c3a/filetype-1.0.7.tar.gz"
    sha256 "da393ece8d98b47edf2dd5a85a2c8733e44b769e32c71af4cd96ed8d38d96aa7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    python3 = "python3.10"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    bin_before = Dir[libexec/"bin/*"].to_set
    system libexec/"bin"/python3, *Language::Python.setup_install_args(libexec, python3)
    bin.install_symlink (Dir[libexec/"bin/*"].to_set - bin_before).to_a
    share.install Dir["docs/*"]
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
