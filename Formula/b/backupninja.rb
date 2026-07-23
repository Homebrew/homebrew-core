class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/liberate/backupninja"
  url "https://0xacab.org/liberate/backupninja/-/archive/backupninja_upstream/1.2.2/backupninja-backupninja_upstream-1.2.2.tar.gz"
  sha256 "93ddc72f085d46145b289d35dac1d72e998c15bec1833db78e474b53c9768774"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^backupninja[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be738649dff8457723e0ea495cc0465166b65d4fe880d303255b2c0c7e579770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be738649dff8457723e0ea495cc0465166b65d4fe880d303255b2c0c7e579770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be738649dff8457723e0ea495cc0465166b65d4fe880d303255b2c0c7e579770"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb2a9e90ab34fe14f75996abb1ff9c6512a32aa9ecef2411fdf607c6ce4cbce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51d04199b4a1284612e6d1ff704412738c400bb844808c6a4348264ac3b67753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d04199b4a1284612e6d1ff704412738c400bb844808c6a4348264ac3b67753"
  end

  depends_on "dialog"

  on_macos do
    depends_on "bash"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    args << "BASH=#{formula_opt_bin("bash")}/bash" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (var/"log").mkpath
  end

  test do
    assert_match "root", shell_output("#{sbin}/backupninja -h", 3)
  end
end
