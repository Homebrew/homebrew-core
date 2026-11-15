class Qdl < Formula
  desc "Flash firmware on Qualcomm-based devices via USB Emergency Download (EDL) mode"
  homepage "https://github.com/linux-msm/qdl"
  url "https://github.com/linux-msm/qdl/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "0718e04e9c5dfd3228a9966e891ed5005a9f88b3b3e02cf13a5173296cf0e52d"
  license "BSD-3-Clause"
  head "https://github.com/linux-msm/qdl.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6d1dc22f9d560a07aac95a4af1a150443f843ee8f56a49838ac443c497d78680"
    sha256 cellar: :any, arm64_tahoe:       "b8a10f455272fbe894d6470fbcb4be854ee2a0992f3bd1a373894418fa83e282"
    sha256 cellar: :any, arm64_sequoia:     "74ca0a6c32cf8e6ba64af83e969537fc821a2ca896b4d891cbef411647902ccc"
    sha256 cellar: :any, arm64_linux:       "ae28ee5bc8e171867dd754588e8fdbb6dae03519c7d3a66961d79cf44b4653b6"
    sha256 cellar: :any, x86_64_linux:      "55b8afb95e9d6f2d5e6fb83198f758920bc30f1bcaebbe74c0ee2002d3c53bf5"
  end

  depends_on "help2man" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"
  depends_on "libzip"

  uses_from_macos "libxml2"

  deny_network_access!

  def install
    args = %W[
      -DVERSION=v#{version}
      -Dnbdkit=disabled
      -Dtests=disabled
      -Dudevrulesdir=#{lib}/udev/rules.d
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qdl --version")

    (testpath/"prog_firehose_ddr.elf").write "\0" * 1024
    (testpath/"efi.bin").write "\0" * 8192
    (testpath/"rawprogram0.xml").write <<~XML
      <?xml version="1.0" ?>
      <data>
        <program SECTOR_SIZE_IN_BYTES="4096" file_sector_offset="0" filename="efi.bin" label="efi" num_partition_sectors="2" physical_partition_number="0" size_in_KB="8.0" sparse="false" start_byte_hex="0x6000" start_sector="6"/>
      </data>
    XML

    (testpath/"vip").mkpath
    system bin/"qdl", "--dry-run", "--create-digests=#{testpath}/vip",
           "prog_firehose_ddr.elf", "rawprogram0.xml"
    assert_path_exists testpath/"vip/DigestsToSign.bin"
    assert_predicate (testpath/"vip/DigestsToSign.bin").size, :positive?
  end
end
