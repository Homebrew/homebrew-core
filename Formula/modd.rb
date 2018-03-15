class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.5.tar.gz"
  sha256 "784e8d542f0266a68d32e920b18e2d690402cf31305314b967186e12ce12099a"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1cd86784da139889806ebc29923105067386636a1724599c6ebe91a7bf468e8e" => :high_sierra
    sha256 "bc0db4fed7c8bcbcd453a1aad44dc2086e1e78dbebf3605783ba1ca21882fa29" => :sierra
    sha256 "e9cc57f8ad0c8c8d442d9f4b4508cacca5b2500b0861542c18e0b757ca2b8335" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/cortesi/modd").install buildpath.children
    cd "src/github.com/cortesi/modd" do
      system "go", "install", ".../cmd/modd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/modd")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Error reading config file ./modd.conf", io.read
  end
end
