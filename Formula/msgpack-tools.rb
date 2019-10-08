class MsgpackTools < Formula
  desc "Command-line tools for converting between MessagePack and JSON"
  homepage "https://github.com/ludocode/msgpack-tools"
  url "https://github.com/ludocode/msgpack-tools/releases/download/v0.6/msgpack-tools-0.6.tar.gz"
  sha256 "98c8b789dced626b5b48261b047e2124d256e5b5d4fbbabdafe533c0bd712834"

  bottle do
    cellar :any_skip_relocation
    sha256 "30f69cfbcfe93c148fec339d86775357cc804f50c58c42594708f7ae9abad226" => :mojave
    sha256 "9c12c496640b2913caa23147bdacffed803115e68607c56975bdab106b4b83b0" => :high_sierra
    sha256 "c576acc7e6078360a79bf7270336e0f3dc9012161e860681cbfe7f2de1313857" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    json_data = '{"hello":"world"}'
    assert_equal json_data,
      pipe_output("#{bin}/json2msgpack | #{bin}/msgpack2json", json_data, 0)
  end
end
