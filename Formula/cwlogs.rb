class Cwlogs < Formula
  desc "CLI tool for reading logs from Cloudwatch Logs"
  homepage "https://github.com/segmentio/cwlogs"
  url "https://github.com/segmentio/cwlogs/archive/v1.2.0.tar.gz"
  sha256 "3f7b56b49c42c1de0e697fc391abad07b03434cff36b153249dd2af3107e064e"

  bottle do
    cellar :any_skip_relocation
    sha256 "094c93934776870df7b417ea5099a604fd8312e1bfa67f27628fa73f2c5dc388" => :mojave
    sha256 "1c07bb31b455ea7e28f55854424b9fbcba9f9ab9e352f759377d7152b1b3c367" => :high_sierra
    sha256 "b3528646611cd4f462bafe83c25c84f551e191629a93a84b11c872f9e86b720f" => :sierra
    sha256 "6384495666e5235c5969ccd1688092fe335a5147b31156e1cb658a41594ae594" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/segmentio/cwlogs"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/cwlogs" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"cwlogs",
                   "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/cwlogs help")
    assert_match "cloudwatch logs", output
  end
end
