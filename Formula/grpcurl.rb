class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.3.2.tar.gz"
  sha256 "3b0b9efc187d86658d241642325fa0dbc3e408ec33ff375d6bd4adf373fa1a9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "16ee49a0ac440459465ab04e793c1d858f536f52379e93f250b0612350f5506b" => :mojave
    sha256 "29f092ad345a777fbc9577dc65adcc96b88e8021ddcf141d0429cb7dfa17414b" => :high_sierra
    sha256 "f30206d5bf254f592d434db330092af6362dc7e12aaf1a628b7a2d79e2c05e5e" => :sierra
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
