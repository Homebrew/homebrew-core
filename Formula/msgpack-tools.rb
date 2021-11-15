class MsgpackTools < Formula
  desc "Command-line tools for converting between MessagePack and JSON"
  homepage "https://github.com/ludocode/msgpack-tools"
  url "https://github.com/ludocode/msgpack-tools/releases/download/v0.6/msgpack-tools-0.6.tar.gz"
  sha256 "98c8b789dced626b5b48261b047e2124d256e5b5d4fbbabdafe533c0bd712834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4bf0c32cce899c521d54e6f26f7bd60c10ad64d4054df064ee42b4437ad9178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "775db49a7259ddf909dd2a05a529e7e308cc2ac376ad116c1668bb659bd34a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d663e0e00679aba8e9bba953aeb99ca657cfd8206769447e6459c33433f6d05"
    sha256 cellar: :any_skip_relocation, big_sur:        "570a72e93de0677f94a586cb49e04ac1fe68655e451860d45a250702fc6e0383"
    sha256 cellar: :any_skip_relocation, catalina:       "901f0f7dadb40b70b20de05a699e5cd9ca37095f3ce9bb277aff3e4421219290"
    sha256 cellar: :any_skip_relocation, mojave:         "30f69cfbcfe93c148fec339d86775357cc804f50c58c42594708f7ae9abad226"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9c12c496640b2913caa23147bdacffed803115e68607c56975bdab106b4b83b0"
    sha256 cellar: :any_skip_relocation, sierra:         "c576acc7e6078360a79bf7270336e0f3dc9012161e860681cbfe7f2de1313857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b6b16502ad2f612e795d483643499defe5839db98bfb92668d89cae76355b8"
  end

  depends_on "cmake" => :build

  conflicts_with "remarshal", because: "both install 'json2msgpack' binary"

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
