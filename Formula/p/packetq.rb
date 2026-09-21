class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.4.tar.gz"
  sha256 "9e2e72a37db9449aa0cae997b35ba7b80e4c1a88fc646e2299fd823769824929"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae61213865e69472a189ed5e0f745e61ea88117a57438927bafa05f10adf4b36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07058bd8ef754f321a06312d752c0700918df1ef93c3a8bfd7333de5d74440f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec0ab5d6534cda819fadd75cfb0d146ca330858fce4b16f36b5b819e44c8623a"
    sha256 cellar: :any,                 arm64_linux:       "fec19271ac1d3939a1f307a8fc615804d417d764bc682fabee8e2d7e253fd101"
    sha256 cellar: :any,                 x86_64_linux:      "6c61f563c1972dadd5ea06d75434c43d9d892f37a35d9fd80b4d59ce7c8c5ea3"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
