class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/grepip-1.2.2.tar.gz"
  sha256 "2ed9477bc5599a10348a7026968242fb4609e6b580c04aaae46d7c71b9fa3d55"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22b47360d59e127a7ef33ec598cbae91fbc393d2c4a7d787a589bf1e308e9695"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef333d42f469784211e7520c89ac8ac07014ca9e56a7ef3a87a29749ddae30dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef333d42f469784211e7520c89ac8ac07014ca9e56a7ef3a87a29749ddae30dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef333d42f469784211e7520c89ac8ac07014ca9e56a7ef3a87a29749ddae30dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d831e7a316e08e58f230b208ed0b7a5db4b2c3ae425dbb71a52b1099d15bf77b"
    sha256 cellar: :any_skip_relocation, ventura:       "d831e7a316e08e58f230b208ed0b7a5db4b2c3ae425dbb71a52b1099d15bf77b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2ad83ecab46b2e50890c75e9e583b060de0fb480da868639645ad48702f84b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89fb159a561f18bd7ddb41e4fe0e280d1aa632165f0b887d4ce2c04af65633bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./grepip"

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
