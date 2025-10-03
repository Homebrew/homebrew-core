class MsgpackTools < Formula
  desc "Command-line tools for converting between MessagePack and JSON"
  homepage "https://github.com/ludocode/msgpack-tools"
  url "https://github.com/ludocode/msgpack-tools/releases/download/v0.6/msgpack-tools-0.6.tar.gz"
  sha256 "98c8b789dced626b5b48261b047e2124d256e5b5d4fbbabdafe533c0bd712834"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d93b03564547f8828bbf33256496b8d132d362bb57a19dc31eaf90bb91f257a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "89db8ac554a849076b6b033ccd4d01758772b92c528107049b1ad0df61e3adcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89cbb09892efa84ffed3f4b4184d91a42526e0884034d00edfcff5ef914acf27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0efee2e7c968df487992d42aa94cc349e9d64762331226b637efe8853ba15d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4bf0c32cce899c521d54e6f26f7bd60c10ad64d4054df064ee42b4437ad9178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "775db49a7259ddf909dd2a05a529e7e308cc2ac376ad116c1668bb659bd34a1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4999dde3a882d85ed7afada6d7366d13bfabc1d37614f06a2510cf97baf1f65"
    sha256 cellar: :any_skip_relocation, ventura:        "6606dc9490eafb04a6078c34847f311aeb4460d28cf2fc90bb0fa3622904a502"
    sha256 cellar: :any_skip_relocation, monterey:       "8d663e0e00679aba8e9bba953aeb99ca657cfd8206769447e6459c33433f6d05"
    sha256 cellar: :any_skip_relocation, big_sur:        "570a72e93de0677f94a586cb49e04ac1fe68655e451860d45a250702fc6e0383"
    sha256 cellar: :any_skip_relocation, catalina:       "901f0f7dadb40b70b20de05a699e5cd9ca37095f3ce9bb277aff3e4421219290"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d52fc61e8c6c211c80b07bd7b49e8c459edc6b7ecb4ce9b711f3fcbd9548988c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b6b16502ad2f612e795d483643499defe5839db98bfb92668d89cae76355b8"
  end

  depends_on "cmake" => :build

  conflicts_with "remarshal", because: "both install 'json2msgpack' binary"

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    json_data = <<~JSON
      {"hello":"world"}
    JSON

    msgpack_data = pipe_output("#{bin}/json2msgpack", json_data)
    output = pipe_output("#{bin}/msgpack2json", msgpack_data)
    assert_equal json_data.strip, output.strip
  end
end
