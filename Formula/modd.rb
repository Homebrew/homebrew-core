class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.6.tar.gz"
  sha256 "589741193c3a699ca0df0e1f5b957461107376c8442fca97d29f59ec458c264e"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e15fd445ef80f9e2b7f3c8a6736beb9bc1b4333b07c34997dc8c1dc3840a3b98" => :high_sierra
    sha256 "475ede0cbdd203990792dc5d264739cd25c9130a20d6cf44022708de268ed217" => :sierra
    sha256 "1459698f458b67923d07d79ab1afd08e54fda408e31b0c59916b8188fb0ded78" => :el_capitan
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
