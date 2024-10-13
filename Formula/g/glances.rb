class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/1b/98/1ee2cf6c1c3d84f69ba23d5cd77973d04e8bf7136fe7a44416a408e05ff0/glances-4.1.2.tar.gz"
  sha256 "56d954a20b46fee66257331f96e7107284c8d8e9f0c62d86126969e860378978"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "857b5dc4ad874fe0f489d4482900ea41c364c7ae79051874323d60d7fa54c667"
    sha256 cellar: :any,                 arm64_sonoma:  "856416ec01bb948c626e6d61799db0adb408f11c8b12cf71c7e29bfe9f696816"
    sha256 cellar: :any,                 arm64_ventura: "600416de91c40e88bcd0b215cf36413971008a797438a6382bc5868f6ec1490e"
    sha256 cellar: :any,                 sonoma:        "09efc188e35798c3131532979b06e21eabc57d7bc0d0dba5cde713aeee0e5843"
    sha256 cellar: :any,                 ventura:       "ab755ebeda7526af3d9c55bcbbe2911e2cdbe13b79dc4cf0c864ac66250f0813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09efbcca4b774121456601e589999d975272216290c892bba27307d1e1f4062"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.13"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/9e/03/821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845/orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  def install
    virtualenv_install_with_resources

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
