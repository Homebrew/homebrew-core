class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.8.tar.gz"
  sha256 "04e9bacf5a73cddea9455f591700f452d2465001ccc0c8e6f37d27b8b376b6e0"
  license "MIT"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "87423ac35521b65b0d45d6d7a1b0589bbfa57a14b62e3b9dcbb4e1e2a6e2f874" => :big_sur
    sha256 "0657ac604def86ff2bfac4797944290d0fc4afabee8855506901437d2870ce61" => :catalina
    sha256 "c7a4a376466ad627e747c4054e6398fa4a8637e5542c2cf496740ea2b0db79ff" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cortesi/modd").install buildpath.children
    cd "src/github.com/cortesi/modd" do
      system "go", "build", *std_go_args, "./cmd/modd"
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
