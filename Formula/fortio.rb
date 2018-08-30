class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag => "v1.2.1",
      :revision => "4a5012fb92ee87ecbdd80ed2cb031f5cf9c50cbc"

  bottle do
    cellar :any_skip_relocation
    sha256 "8abcb388d6c1737b0cae6c1ae2779c44fa976fb49bf52286e550aec4f53f4bb8" => :mojave
    sha256 "c36297e933f48b4307acbab89d0c2a6b668e6fed1ce4e80315d147452618e769" => :high_sierra
    sha256 "22e5517fdbb61112158dd8e6d99f03430d5f58cc0571bd636de759e71a390792" => :sierra
    sha256 "89c457c56935ac4771ffe48639db8c0a829b1baf37070a4a772859e3de9147ef" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/fortio.org/fortio").install buildpath.children
    cd "src/fortio.org/fortio" do
      system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio",
             "LIB_DIR=#{lib}", "DATA_DIR=."
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
