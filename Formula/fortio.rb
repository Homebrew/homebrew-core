class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag => "v1.3.0",
      :revision => "bf3f2d9ff07ed03ef16be56af20d58dc0300e60f"

  bottle do
    sha256 "1114e2a7b9118aa315ac68e447363c93606046528887ec03b2cac9796049c8f8" => :mojave
    sha256 "6d8f7f7f49a78f4b4098a09139f8c3ed4eeb9449bb8fa18155bfd913787e4d22" => :high_sierra
    sha256 "d99a857e10699fbcacb2898f0295385e9742a9c0a92cbacb73b70d939ae1030c" => :sierra
    sha256 "e999074fdd6de777309dfa615fd357e5d71a31e5877792e5106d455cdd7bc80d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/fortio.org/fortio").install buildpath.children
    cd "src/fortio.org/fortio" do
      system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio",
             "LIB_DIR=#{lib}"
      lib.install "ui/static", "ui/templates"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", "8080"
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:8080/ 2>&1")
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
