class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.12.tar.gz"
  sha256 "8f39ad5f9c076b9c62c67dea4f8649e75dcc16899a2d8122ca32ba68262cb713"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?cabextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a72af65513457bedcdadf111fcb022502ffee4cac6eb0f674a7cf449016f81f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9bf0dafabe848673f7b1501467f1fd99ae9cc11427c1056621e375031ae5dc5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d45444d69bd2332701100c27601e5a009a2f8ccea0b30b159ac4c3c9696f64b"
    sha256 cellar: :any,                 arm64_linux:       "e57ed13cbc70dc64d8146f7650be017e0d422d6286431e5573c6da89cf60bf78"
    sha256 cellar: :any,                 x86_64_linux:      "7cbb01222097fe982c50869945cb672488b367b152fbcbfd460157f0ccda0b38"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<~EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system bin/"cabextract", "test.cab"
    assert_path_exists testpath/"a"
  end
end
