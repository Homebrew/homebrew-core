class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.6.0.tar.gz"
  sha256 "5faa9806308730524e8f6e67bc8d5378261814e5b4869dad2c0696e9d8bc8979"

  bottle do
    cellar :any_skip_relocation
    sha256 "39d8535ec12e81fb2243eaa28a2bff15c5f1022ed709918eb8d23547ebf11e78" => :catalina
    sha256 "38fe5e2ed21bdcbf75aae000c84204a9223ad771e1077873085f6d95b9e6c876" => :mojave
    sha256 "3790eff7e7a9d67280e21a243b021e8ca95788076bbc555ef0db0589aa723eea" => :high_sierra
  end

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
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    EOS
    system "#{bin}/grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
