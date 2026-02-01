class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/cua"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.2.53.tar.gz"
  sha256 "c609e4b4a501d087905c6fd62df759732207e4acd5dc441f5d162521e6639b7c"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39cea5ee0787b1a52fb143cbb993114d86f95c25dd2b2724e9b4d2550dd4e55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a9abb05cab95812a01defa1c1e4c44bcd41348421a1c91deff886d970551cad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afad7d71ef0606fd966d6c068be20b74755a2f2a2ebf97fb6b286c0675941ea6"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  service do
    run [opt_bin/"lume", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/lume.log"
    error_log_path var/"log/lume.log"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    port = free_port
    pid = spawn bin/"lume", "serve", "--port", port.to_s
    sleep 5
    begin
      # Serves 404 Not found if no machines created
      assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
