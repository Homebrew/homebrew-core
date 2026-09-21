class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.11.0.tar.gz"
  sha256 "596389bc8560ea027dff9db8aaf6c173d992366d9aef4baf5d7c6d180b4d49ad"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f1f2643e54877c5ce19c7f1ceb7803c41ad707bc06a5bc9a1ca1e584722e307d"
    sha256 cellar: :any, arm64_tahoe:       "2dda8bce797e75485e684cb14f79bef7cb6ebcb3c2227f97a027537ccca91fbc"
    sha256 cellar: :any, arm64_sequoia:     "8c4b73f9af512cb09adcd8971d3cd584487b34adedc9cfc2e0615a2636b6efe9"
    sha256 cellar: :any, arm64_linux:       "90ba6adb657c90c9cbca41c2bd4ed8b46ebf693408d3162c938029408df11030"
    sha256 cellar: :any, x86_64_linux:      "884fa710f9c26a5fbd6567ae051221317da1ea1edb8cb9ab87d7da3e79acd329"
  end

  keg_only :provided_by_macos

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Exclude unrecognized options
    std_args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }
    system "./configure", "--enable-ipv6", "--disable-universal", *std_args
    system "make", "install"
  end

  test do
    assert_match "lpcap", shell_output("#{bin}/pcap-config --libs")
  end
end
