class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.5.3.1.tar.gz"
  sha256 "04b5c56805895fd15751167ab04c99fa86602110ea7591ef611695de9923911b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "89cb0dc5e300839a09763747a94aa209154571b18cdcf2fe775637c15baeeb56" => :sierra
    sha256 "77178087af402f1d40503abc7f5f66ee2ac9e29d2b745cdf0b636b520a0daeb3" => :el_capitan
    sha256 "27ebfa295ab31cbbeedcc259a9de1600245aedfb1f14c2d885a5a40514a62331" => :yosemite
  end

  needs :cxx11
  depends_on "cmake" => :build

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.7.0.tar.gz"
    sha256 "f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc"
  end

  def install
    ENV.cxx11

    gtest = resource("gtest")
    gtest.verify_download_integrity(gtest.fetch)
    inreplace "src/CMakeLists.txt" do |s|
      s.gsub! "https://github.com/google/googletest/archive/release-1.7.0.zip",
              gtest.cached_download
      s.gsub! "URL_MD5 ef5e700c8a0f3ee123e2e0209b8b4961",
              "URL_HASH SHA256=#{gtest.checksum}"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write Utils.popen_read("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
