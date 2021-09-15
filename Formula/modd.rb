class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.8.tar.gz"
  sha256 "04e9bacf5a73cddea9455f591700f452d2465001ccc0c8e6f37d27b8b376b6e0"
  license "MIT"
  head "https://github.com/cortesi/modd.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1ec2df2d4eacfc45017a547d95f0201a605b65843379b8dfa1772e329a86f19"
    sha256 cellar: :any_skip_relocation, big_sur:       "468d421ccb60b0e236dd15299fd6c09f8dfca1dc67ee73bf17b60d07410417ff"
    sha256 cellar: :any_skip_relocation, catalina:      "d4e92bca2fb812429c92ae88e8e04ef11de28f00eaad8bb42a736965666ff02c"
    sha256 cellar: :any_skip_relocation, mojave:        "a2422e6f5c756a3202b47d58ca88eb6011361445b0ace2198c6f7aaa01eebf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c3ed52b7621ce7aeedb09e6265b8e1ea699cf5d4607a2e01fb15835f6ee206"
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
