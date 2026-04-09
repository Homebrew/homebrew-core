class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://openargus.org"
  url "https://github.com/openargus/argus/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "1718454ac717fe5f500d00ff608097e3c5483f4e138aa789e67e306feb52bafb"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1a76bb7c5737f627ebfc27f321fc34cedc903ae21a33c0a9280529dce6917f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0dea329a17b51f48861d6dbfd53900af81bb75bcd9dd173b8bef89e41a978e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "823afbc6210ecbc3bb273fefd593ee7d3698c8115a3469e1829c902f4c64435e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9216f8cbb95b5f44214aca06da967e5eb97ebd42667c340504bfc04da72bd5cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d84ccbdbdb94cb8281f0e2b529b7389a961f31c86f3fc0fd678a9502460d096a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9988cefee9faa56b8626339270477793a75757df731e86169db368542a1360ad"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libtirpc"
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc"
      ENV.append "LIBS", "-ltirpc"
    end
    system "./configure", "--with-sasl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Pages", shell_output(bin/"argus-vmstat") if OS.mac?
    assert_match "Argus Version #{version}", shell_output("#{sbin}/argus -h", 255)
    system sbin/"argus", "-r", test_fixtures("test.pcap"), "-w", testpath/"test.argus"
    assert_path_exists testpath/"test.argus"
  end
end
