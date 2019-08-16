class MsgpackTools < Formula
  desc "Command-line tools for converting between MessagePack and JSON"
  homepage "https://github.com/ludocode/msgpack-tools"
  url "https://github.com/ludocode/msgpack-tools/releases/download/v0.6/msgpack-tools-0.6.tar.gz"
  sha256 "98c8b789dced626b5b48261b047e2124d256e5b5d4fbbabdafe533c0bd712834"

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
