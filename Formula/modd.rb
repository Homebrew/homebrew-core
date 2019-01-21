class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.8.tar.gz"
  sha256 "04e9bacf5a73cddea9455f591700f452d2465001ccc0c8e6f37d27b8b376b6e0"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33b9f69c73faa25b4bfec3ae6103cca7cd41862a693292fbe934c244b89e3aac" => :mojave
    sha256 "52d2eb11b69f8c6a3eec06e2d60864fd6bb32263f4f47f78d8ccd94f2f595759" => :high_sierra
    sha256 "68214544aa3797bdc878ba397bbb1ca5e100a5159c3b90640f27f5d7ea7215b3" => :sierra
    sha256 "300e0802cff775ae987e3036691b0474aececfb7f83819fdccd7fd1cce88df0e" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
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
