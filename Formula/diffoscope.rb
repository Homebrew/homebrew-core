class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/d0/15/81dfdc3d3b736d0c42832df5d6e20a224d59804e3756826931ca60b4368f/diffoscope-214.tar.gz"
  sha256 "d670774498667be9dde75b14d94f57526834fc6b1d6aff89f6c68570a2246b03"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35afb7b12d0e2fd6f8e28662f95267d9cf5fbd91533a46f1d656e03e4af9aa59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1514c220a6f3039b53b2d0c31562ad98c6156ccf180ab3250b1fa154638536d7"
    sha256 cellar: :any_skip_relocation, monterey:       "54caf489e992f7d392147a06d91c98d6e767d735037afa6a5b4405d210898917"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef303bee772a5e1c72076547c16813f064eca31226b349691697a80962b7861b"
    sha256 cellar: :any_skip_relocation, catalina:       "291c9f2a7da770b7cbc5f0edc79ba35eb7d7cea722a23037a2e8ef6a4ade5e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a58837f5e1cc05b491f985fb1520a57d64fc3e34d9ed441d04fe1e2555769ca"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/f7/46/fecfd32c126d26c8dd5287095cad01356ec0a761205f0b9255998bff96d1/python-magic-0.4.25.tar.gz"
    sha256 "21f5f542aa0330f5c8a64442528542f6215c8e18d2466b399b0d9d39356d83fc"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
