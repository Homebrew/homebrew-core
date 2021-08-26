class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.8.tar.gz"
  sha256 "04e9bacf5a73cddea9455f591700f452d2465001ccc0c8e6f37d27b8b376b6e0"
  license "MIT"
  head "https://github.com/cortesi/modd.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc3e926bb7282bd2019350646a48ec7fe88f1fb65e41156d250f3c969e7245ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "87423ac35521b65b0d45d6d7a1b0589bbfa57a14b62e3b9dcbb4e1e2a6e2f874"
    sha256 cellar: :any_skip_relocation, catalina:      "0657ac604def86ff2bfac4797944290d0fc4afabee8855506901437d2870ce61"
    sha256 cellar: :any_skip_relocation, mojave:        "c7a4a376466ad627e747c4054e6398fa4a8637e5542c2cf496740ea2b0db79ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ecbbb67e695368d3830b5c273f6abf7f659b73bcfe47c3f18332cf76fedf997"
  end

  # https://github.com/cortesi/modd/issues/96
  deprecate! date: "2021-08-27", because: :unmaintained

  depends_on "go@1.16" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
