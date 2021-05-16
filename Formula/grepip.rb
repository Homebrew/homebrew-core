class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/grepip-1.0.2.tar.gz"
  sha256 "f9258f9f5c2bfdb4278c6cd456072664be7588fc6a8b665d35cbd6fa29f57568"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./grepip"
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
