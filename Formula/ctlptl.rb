class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.16.tar.gz"
  sha256 "c82d088e31e56458d9ddb6412e81d173c1eaf996b9b3029834b6026cd3c2124e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bda527d947be111839602e58bcbcb4a69a7375d9cfdf6d9a6a1c1ead7ef92e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc24f6b0019cd2716c0434ee5c0f42a89ff3bf898602ad2bfa25186bfa6a248b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "517149b22ec8e443cea689404a4e716f50a9ecd45a548a6a21d15f2d8d692a48"
    sha256 cellar: :any_skip_relocation, ventura:        "8e5c39796738ac0cd2c14a834d5e293cfef7a5f1d1eed33ec7d881a186222a31"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb8b3552c838a576ae0dcf32c317ece64e6b7d9f83edf99cf81086231fcb8d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1909a610d26c3b8674627ab0f609b445257172608957eb33fa5c37d34ab3555d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ec46d480861dcf5993172929e989c7d50cf323236ec53688b3834346a44a31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
