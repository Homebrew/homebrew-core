class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.0.0.tar.gz"
  sha256 "7bb34f0bc08046feb093871898b1abc197cd75054dd80bd73167246caadd094c"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/fullstorydev/grpcurl").install buildpath.children
    cd "src/github.com/fullstorydev/grpcurl/cmd" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
             "-o", bin/"grpcurl", "./..."
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/grpcurl", "-help"
  end
end
