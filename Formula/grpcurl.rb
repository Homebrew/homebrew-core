class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.4.0.tar.gz"
  sha256 "183884375171db964e47ef778ef57764ceebebae0c6ea73ae028fb700b8a2c13"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dc4195a050588d6a9ef9825a2c70e0dba4d5c6c1178c9d2689ea3a93d5c166b" => :catalina
    sha256 "130085a5a3429f642b65659504ea47767271ecbb98a8b8e0c0eb60925894114e" => :mojave
    sha256 "cf3e2d3ea747ee2dd39ab6d94111864cac2b9a990e53416055697f165e93782b" => :high_sierra
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
