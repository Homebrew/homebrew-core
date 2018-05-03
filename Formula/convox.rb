class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180503151229.tar.gz"
  sha256 "29a9571b3ae845d0f23a0ce28bafc96dbd8d6ee20110cf8e46208bb4e9a47db5"

  bottle do
    cellar :any_skip_relocation
    sha256 "af793752020fc260de7a7b0d86867fa884a107a3e26fc19f06769d2cabb8fe47" => :high_sierra
    sha256 "1d041d570f878d4e92550e6190ff1f921c46a9d481830c9ba10fe569e8b8d414" => :sierra
    sha256 "8a9519a6ae067a49fb8b21bbfe0ea4b7bf8dd3014da94e855b3ca00936ba68b5" => :el_capitan
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
