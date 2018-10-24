class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.8.tar.gz"
  sha256 "a73bd347f0d0f452be183e365492fb8bb86954b3cd837c9dfe256926bf7feb5b"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef6dc8dbc417a9fb4fb8f243914fa56e3e3fadd67cb87d0c2b33c5ba214d77ef" => :mojave
    sha256 "9878d5e45b60321b29c33fd638465341ef05fcd4debec02c3fafe8c1d7d7c3f7" => :high_sierra
    sha256 "d2f4d38612065cc367a539aa19d8630c5e4650631eed767740313819d0556dbc" => :sierra
    sha256 "d6ff3c9d3cc56571cba4ba8a6131ce124877d73275f9e0f41514fec1bfa8bed0" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cortesi/devd").install buildpath.children
    cd "src/github.com/cortesi/devd" do
      system "go", "build", "-o", bin/"devd", ".../cmd/devd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/devd -s #{testpath}")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Listening on https://devd.io", io.read
  end
end
