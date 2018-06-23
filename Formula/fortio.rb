class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :tag => "v1.0.0",
      :revision => "b508c4b471a13fbe9f2e219ab6091e8f688b9836"

  bottle do
    rebuild 1
    sha256 "cd84e49fc3a526b7e51282768a897debae0b3e0c5a5c8f6a6a6f4ad44b8a3847" => :high_sierra
    sha256 "d4f5f03c684d494702a97b3704cb6af25684fb5a9f3b2d9e83c058d9e4b12174" => :sierra
    sha256 "92ed42bb9ccdbdbee9ab5959708197d26e7bf3a486fd4e68ece0479d5249b1bc" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/istio.io/fortio").install buildpath.children
    cd "src/istio.io/fortio" do
      system "make", "official-build", "GOOS=darwin",
             "OFFICIAL_BIN=#{bin}/fortio", "LIB_DIR=#{lib}", "DATA_DIR=."
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
