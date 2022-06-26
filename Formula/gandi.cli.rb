class GandiCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to Gandi.net products using the public API"
  homepage "https://cli.gandi.net/"
  url "https://files.pythonhosted.org/packages/cf/00/ff5acd1c9a0cfbb1a81a9f44ef4a745f31bb413869ae93295f8f5778cc4c/gandi.cli-1.6.tar.gz"
  sha256 "af59bf81a5a434dd3a5bc728a9475d80491ed73ce4343f2c1f479cbba09266c0"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a51b821358228a6eda89d5871ed61a576d29157751c94f31fb9dab31dcbe5a59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f92e3816c8cb90e68025ff5cf626d5f7e0c4077bf759a6dc36336e6288200145"
    sha256 cellar: :any_skip_relocation, monterey:       "85d5158ef37b4b330e2603d2dca062b38c68291a9e6e798f8a67b10c176a9a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "11e62f36fadd38cc20d2e178abaf7ba5bbe34595c5c51229e0b0c7fc3813a714"
    sha256 cellar: :any_skip_relocation, catalina:       "612bd7ab8250d396f355bdb48c3a71a615b23c6631512721a1e76507484d8365"
    sha256 cellar: :any_skip_relocation, mojave:         "80259a08cef78b9e5b4197a589b592e88a061586edad0a60eb7af495e567fbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1285c7114f0dea5d293a775ce67fd4a87e0e0550715091781c3dfce578760ac1"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "IPy" do
    url "https://files.pythonhosted.org/packages/64/a4/9c0d88d95666ff1571d7baec6c5e26abc08051801feb6e6ddf40f6027e22/IPy-1.01.tar.gz"
    sha256 "edeca741dea2d54aca568fa23740288c3fe86c0f3ea700344571e9ef14a7cc1a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gandi", "--version"
  end
end
