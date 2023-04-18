class Netmask < Formula
  desc "IP address netmask generation utility"
  homepage "https://github.com/tlby/netmask/blob/master/README"
  url "https://github.com/tlby/netmask/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "7e4801029a1db868cfb98661bcfdf2152e49d436d41f8748f124d1f4a3409d83"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b933d4ec7f084d202afd3b48feb3230c7eed31ec58b1aa0dd87f2b87d1397a6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e386fc98127ef24109de173931633f0705dc8963e7e5a236ed69991e280d116c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "611337cf807c5344df21127e4e0b982e8454237256779683346ff39adebd634d"
    sha256 cellar: :any_skip_relocation, ventura:        "9388589b57733eda2e0cf8ec83bb49de8222603f5c7286b4dc6b57c69063a677"
    sha256 cellar: :any_skip_relocation, monterey:       "278a82473770a98ef3704737f2c2f4902ad818af931ff3bb872798f3c9169424"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e304176fcc71ee0657520960c4e6b12304ef9bce2a73135b5ff69d0fe68e2ac"
    sha256 cellar: :any_skip_relocation, catalina:       "1561dc4ab182e2a3ac7f66553f9a7695683467201355969a041199464333c029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb4bad8bac486dc82f994b64c823e9830afc267992fbe48dfda89eb7687729a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./autogen"
    system "./configure"
    system "make"
    bin.install "netmask"
  end

  test do
    assert_equal "100.64.0.0/10", shell_output("#{bin}/netmask -c 100.64.0.0:100.127.255.255").strip
  end
end
