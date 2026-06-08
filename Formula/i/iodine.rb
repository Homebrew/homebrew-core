class Iodine < Formula
  desc "Tunnel IPv4 traffic through a DNS server"
  homepage "https://code.kryo.se/iodine"
  url "https://github.com/yarrick/iodine/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ffc7a58cdde390a01580f4cfc78c446b0965bcb719bde2c68c5e0c27345a8dfc"
  license "ISC"
  head "https://github.com/yarrick/iodine.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8e87d64fdc26c599c69d781412172b9393917733d1994e3687f4c435d32fa0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6665baf56a99f8935d607204ce6e04bbe5cfbd3955391b83eea7841e493e7cb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827a52aaabfea1e49e71eedef3939dda8a6434e5c99f41ad45c3e562d0a8fb92"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab1dad85f08ae67fef8adfff742b87f8771351448a2dc30cf0ea3c8f28ab1350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b07d712bd33ca41e4f06ddd68e3976371e7cc79fd5a4ad26614bcc0cfb4bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba56bb7d3d06fd6fd4fa2ca908c17dec0b5724a49247c105c456b57c6b4111f8"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # iodine and iodined require being run as root. Match on the non-root error text, which is printed to
    # stderr, as a successful test
    assert_match("iodine: Run as root and you'll be happy.", pipe_output("#{sbin}/iodine google.com 2>&1"))
    assert_match("iodined: Run as root and you'll be happy.", pipe_output("#{sbin}/iodined google.com 2>&1"))
  end
end
