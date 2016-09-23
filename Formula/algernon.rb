class Algernon < Formula
  desc "HTTP/2 web server with built-in support for Lua and templates"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/v1.tar.gz"
  sha256 "048f76ced4bddc81bfb347e64ae6f47100c8ebb010188d258aa443a4f3a3b42c"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "028119c7c15e53897c83591fddd55afac2cc8ba73a0f140696627b0540ee11f1" => :sierra
    sha256 "2e16b42c99ce802610bf286f9d2a54d0190d76ac8a2b47df3f6f395bf2b47205" => :el_capitan
    sha256 "a7a330affb93d8a71e0dfb0bf8bef1bacce83964b5c0b1f9d20f31abcd5f9f9c" => :yosemite
  end

  depends_on "go" => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyproto/algernon").install buildpath.children
    cd "src/github.com/xyproto/algernon" do
      system "go", "build", "-o", "algernon"

      bin.install "desktop/mdview"
      bin.install "algernon"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "my.db",
                                "--addr", ":45678"
      end
      sleep(1)
      output = shell_output("curl -sIm3 -o- http://localhost:45678")
      assert_match /200 OK.*Server: Algernon/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
