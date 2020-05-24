class Podtnl < Formula
  desc "Expose your pod to Online from any kubernetes clusters"
  homepage "https://podtnl.sh"
  url "https://github.com/narendranathreddythota/podtnl/archive/1.0.tar.gz"
  sha256 "e94d28fae97ee38ee3f4b3a502df5c510280eb49868aeb2cad40a7266158c0cc"
  head "https://github.com/narendranathreddythota/podtnl.git"
  depends_on "go" => :build
  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/narendranathreddythota/podtnl"
    path.install Dir["*"]
    cd path do
      system "go", "build", "-o", "#{bin}/podtnl"
    end
  end
  test do
    system "#{bin}/podtnl", "-v"
  end
end
