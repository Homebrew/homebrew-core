class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/grepip-3.3.4.tar.gz"
  sha256 "c3d843248818733f032474ac19357d32f3d35b81c4276dcd091dbe65a4b50f45"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f43ab994d404c100b91448e83dc90f6b16d596b68f4c6e548ad6bc65a901e3d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f43ab994d404c100b91448e83dc90f6b16d596b68f4c6e548ad6bc65a901e3d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f43ab994d404c100b91448e83dc90f6b16d596b68f4c6e548ad6bc65a901e3d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab270c15148698a0b826abdacade95a2e221d743cd2d4fc94ec03fca7063ff27"
    sha256 cellar: :any,                 x86_64_linux:      "2d1eec640f7b05a0f349caf1a195a68f262a09ad02700d1a569c5cf8790c7bd6"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./grepip"

    generate_completions_from_executable(bin/"grepip", shell_parameter_format: "--completions-")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/grepip --version").chomp
    assert_equal "1.1.1.1", pipe_output("#{bin}/grepip -o", "asdf 1.1.1.1 asdf").chomp

    (testpath/"access.log").write <<~EOS
      127.0.0.1 valid ip but reserved
      111.119.187.44 valid ip
      8.8.8. invalid ip
      no ip
    EOS
    output = shell_output("#{bin}/grepip --exclude-reserved -h access.log")
    assert_equal "111.119.187.44 valid ip", output.strip
  end
end
