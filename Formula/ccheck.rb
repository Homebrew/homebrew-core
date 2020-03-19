class Ccheck < Formula
  desc "Check X509 certificate expiration from the command-line, with TAP output"
  homepage "https://github.com/nerdlem/ccheck"
  url "https://github.com/nerdlem/ccheck/archive/v1.0.1.tar.gz"
  sha256 "2325ea8476cce5111b8f848ca696409092b1d1d9c41bd46de7e3145374ed32cf"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"ccheck", "main.go"
    prefix.install_metafiles
  end

  test do
    assert_equal "brew-ccheck.libertad.link:443 TLS",
    shell_output("#{bin}/ccheck brew-ccheck.libertad.link:443").strip
  end
end
