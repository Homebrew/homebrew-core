class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.3.2.tar.gz"
  sha256 "3b0b9efc187d86658d241642325fa0dbc3e408ec33ff375d6bd4adf373fa1a9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "de77cd2b5df78d5dcef4b1e320f0978faebdc96a4970850689a2ea7e1d35d718" => :mojave
    sha256 "03e243c991d3462235b16d324274ee15dc3c2f2456f11340aa5b4630e2670e38" => :high_sierra
    sha256 "6d41a079f194494a060a6ef41b5a2880febb0593b8051ded2d22b67404768f6f" => :sierra
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
