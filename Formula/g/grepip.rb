class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/grepip-3.3.3.tar.gz"
  sha256 "0c76734ce34573999def6abf0eb3087669af6898ec307308d39aae7994d57389"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "809aafcba8b6fb8eefc407a159bea7a540fbc20cb553a1bfd6ac6522f852fbd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "809aafcba8b6fb8eefc407a159bea7a540fbc20cb553a1bfd6ac6522f852fbd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "809aafcba8b6fb8eefc407a159bea7a540fbc20cb553a1bfd6ac6522f852fbd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60f913de4ec38349b665bc204f7f45a8bfaa74a1adccf3a7e3ca9b288065c879"
    sha256 cellar: :any,                 x86_64_linux:      "279883d3208201e3a3644a7167712a665a3b83939dc4bbd3e6a4a2640ca67d6a"
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
