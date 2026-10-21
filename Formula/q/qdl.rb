class Qdl < Formula
  desc "Flash firmware on Qualcomm-based devices via USB Emergency Download (EDL) mode"
  homepage "https://github.com/linux-msm/qdl"
  url "https://github.com/linux-msm/qdl/archive/refs/tags/v2.8.tar.gz"
  sha256 "48be6f6f7869fa73432dbdde20aefc2963f9c84a10e066ae523145c26314f88d"
  license "BSD-3-Clause"
  head "https://github.com/linux-msm/qdl.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83c0c15c1edf2f49c6d78d4f42630634b2565a2a4777684bee316dbf927ed367"
    sha256 cellar: :any, arm64_tahoe:       "c43438c633fc5b9da420e3e45796f01baeaca18c1cd675fa790fc96c380a7fb2"
    sha256 cellar: :any, arm64_sequoia:     "196073586aae1ef5b115bbfb2250a418cff2bc2c8e2100a05d21af512eacb05a"
    sha256 cellar: :any, arm64_linux:       "88b1b9fc24983223fe9cd3d5a5a32a465775cc82c63e2b77363c351b5c80cdc0"
    sha256 cellar: :any, x86_64_linux:      "e8a3a741cf52cd92b695c28661c9c4a3efbaffb2afd7898ef9850d8c39fe5ae7"
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
