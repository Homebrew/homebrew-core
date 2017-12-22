class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.5.tar.gz"
  sha256 "784e8d542f0266a68d32e920b18e2d690402cf31305314b967186e12ce12099a"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44dded2d206255b1865b33569f413e305a28a91bb3af6c3b29e26ca4726a0e42" => :high_sierra
    sha256 "1102b677003a7d0f2b2af3b9da58dcea26af6d86f655ca6c1ae416947173a2e3" => :sierra
    sha256 "bb7190f3c846327c782f719c5c592104fcdb1598586d6ad13cda57c5b72468df" => :el_capitan
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
