class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.2.1.tar.gz"
  sha256 "7fc2c263b6c89aa5be2379bb1606fe435a937f13f2652141da5b9280fde41307"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4404289bcc9e02585c9afbf73ce7372c426d2274ebb28a7764bef51964bce38" => :mojave
    sha256 "366f1e6b432335bad1d04e1fed44f3789a25430af1b6ee172bea024832d823b5" => :high_sierra
    sha256 "378fee0c7f67ef2bf3333fa01db7b833cfa477f457ab9bd904eb90c47d2f92eb" => :sierra
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
