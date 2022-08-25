class Netdiscover < Formula
  desc "Active/passive ARP reconnaissance tool"
  homepage "https://github.com/netdiscover-scanner/netdiscover"
  url "https://github.com/netdiscover-scanner/netdiscover/archive/refs/tags/0.9.tar.gz"
  sha256 "dc436992cae0e61ad8d14e1fb4d2650ec9e754c0024010e15d341afb98e28f70"
  license "GPL-3.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    help_output = pipe_output("#{sbin}/netdiscover -h").split("\n")

    expect_line_1 = "Netdiscover #{version} [Active/passive ARP reconnaissance tool]"
    expect_line_4 = "Usage: "
    expect_line_4.concat("#{sbin}/netdiscover ")
    expect_line_4.concat("[-i device] [-r range | -l file | -p] [-m file] [-F filter]")
    expect_line_4.concat(" [-s time] [-c count] [-n node] [-dfPLNS]")

    assert_match expect_line_1, help_output[0]
    assert_match expect_line_4, help_output[3]
  end
end
