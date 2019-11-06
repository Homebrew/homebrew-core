class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.3.1",
      :revision => "fd8f4a7177e9ea509f27105ae4e55e6c68ece6f7"

  bottle do
    sha256 "6ee4178877f572edb23e93f2d06ef2292cdfd6f4c70b38244ff082cee125e254" => :catalina
    sha256 "467956dd9643ecb9b349ce87c854e847d3880afe1e71deb2eb50bf57a8af6e98" => :mojave
    sha256 "638e50aa75d32f0a9aae6243061df73ed7660fb055a3fcc30b9ee0afc3b19f5b" => :high_sierra
    sha256 "663aa97525d032d3de935b487183ee478e2d18f92a4c82737a72ac5ed6c648a9" => :sierra
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
