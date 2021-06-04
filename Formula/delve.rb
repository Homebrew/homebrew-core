class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.6.1.tar.gz"
  sha256 "e73f7fc063632268d3bdf53486aeafd98cceb8f86f4af56903dedfebaefe690d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e774b975565bfaec8dd6a22418cda775b8fe3acc8f034d213138a38d2f19447f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b0fae4fe6dd4c9c1f68580488cef94724b4924d9f3525649b0dbb807c727bf0"
    sha256 cellar: :any_skip_relocation, catalina:      "03579fd98b3589a702435838e71b26395fcce0dea8529198740dc5038e6e3ed0"
    sha256 cellar: :any_skip_relocation, mojave:        "5a75f2840dddefedc3ebe81d33bc5641e25c45cdcdf74db9469d4c2f8705495e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"dlv", "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
