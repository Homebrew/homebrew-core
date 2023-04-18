class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      tag:      "2.0.4",
      revision: "e015a55faa940cde2bc7b38af65709d52235eaca"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70ad5b476c921a644756f5cdcad35654e6cbfda98761c1492db552cfb5c83119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37172967c61a7722ba51110498e5cfeb04a3fa6b7b7f9c45ea97021095558b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "656132636af7921e6a2e20b12115ce419ba228167389c41d8d0b2b1a57f3b201"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f576b680ef04f935c3af7fd7e1ababdfd8b073659594ad81243018ef3b6cc76"
    sha256 cellar: :any_skip_relocation, catalina:       "89367dad83660f1fc7deae319233bc4b554b92bb0faf406d14ff5145d70226d3"
    sha256 cellar: :any_skip_relocation, mojave:         "9f491e354dc372c864fa2ea747ec3f514071b5fe0ad5f2649818c1e788ce97d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7c60bf096b4333d3e62e3cd994853dfb6ac2db505f4f453fb52ba734625c14e"
  end

  disable! date: "2022-07-31", because: :repo_archived

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "zip" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/goadapp/goad"
    dir.install buildpath.children

    cd dir do
      system "make", "build"
      bin.install "build/goad"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goad", "--version"
  end
end
