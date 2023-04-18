class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "cd9a065dd1c3477f6172a0156294f767688847e4d170103d1f08b3a075f82826"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v1.03"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84e1dd751ad7f76185abdb9d037387fc8ff8f78962521f641f5ce09ba6657360"
    sha256 cellar: :any,                 arm64_monterey: "cd00d6cd6f106536cbc112c99467c6dc74b2acbffb1ea00bf7c01e3ca0217962"
    sha256 cellar: :any,                 arm64_big_sur:  "a338784e3a2208443d87601cb991671049de6c1ccafbe1b67c6138ecc7d8e327"
    sha256 cellar: :any,                 ventura:        "49f69b6b8e634f183bf90d9c402287cfc0977847844bb4685abaef6e0dc5bb00"
    sha256 cellar: :any,                 monterey:       "27a4827a1f91d6c03080ce82f59269de4f47240927f00d4a12006dba5d016cc8"
    sha256 cellar: :any,                 big_sur:        "0321ce7f26dadb87386fb44a40d88e6536b87b2b66f50152104c58628b4d419c"
    sha256 cellar: :any,                 catalina:       "5b359ad9a7919a7df40fd5048ad6f2b54a374fba46ffb7f0796e1627a8326a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a16d4e19103a603da6ab2c02534a2cbf1d9bf77a00b29a75ced47d2e52292f96"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"
      system "make", "install"

      bin.install "demo/c2demo"
      bin.install Dir["src/c2*"]
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
