class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.9.tar.gz"
  sha256 "5aee062c49ffba1e596713c0c32d88340360744f57619f95809d01c59bff071f"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d394040c10c42a1e4ac22af9fff69a8fa93e26cdbc3c9d21cec0c1bedb0bfc12" => :catalina
    sha256 "14f2c29b4bd17afe84568daa6800e9500438c28b02b7bc83f2a76252bb79099b" => :mojave
    sha256 "64faee99fcec04c2d603610f169900a1379bd5961be352745078c38dfc5cdb17" => :high_sierra
    sha256 "3023d0d25dbca5e3790fbf42c6f093d8241970700bbb4d6ca7b516c23ff25d77" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
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
