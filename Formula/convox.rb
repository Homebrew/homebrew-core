class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180502151645.tar.gz"
  sha256 "c6bcb546b3095f6995290cf637ec7f49c284220a0d13a1abbab945d0af7a2f29"

  bottle do
    cellar :any_skip_relocation
    sha256 "34d7ecaab7348cead46c2e35bdbf35b70f5b6ac6993b7eba9edf9b6608eeba63" => :high_sierra
    sha256 "3015c73addec352438d1d11e255d365fed909e4de9c101a061422dc46b62a56b" => :sierra
    sha256 "b9259bbf16ddd49bec9a2a080e78da1260f1dc348139d4586c196441fd01d611" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
