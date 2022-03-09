class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.2.tar.gz"
  sha256 "fbf6ea7e1ed0c92e543c7f5f2343928e185e11e4cba1c7c9d3bfc28d1c323900"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "957539f169cc7ec13f2ceea9df59f6ff0792ae1ba85eb05d4033c74685e4f36e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9063fff4cf1c00a915319d2eb1dcdf8d77dd56cab2dd3b90eba0572d1d5e179"
    sha256 cellar: :any_skip_relocation, monterey:       "b979ccf6e22b876b9616cab7b85a491f752c38ba9c34ddc7a180f94610930dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5b22700bfc0154f602b8ba011dc28f6c7dbb404f8d0ba7cd4b2f13d28f19a17"
    sha256 cellar: :any_skip_relocation, catalina:       "a70c4a1439d4c897f9a8cf7f62cca277db7ae84cf35ce076d270ecca0f419db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb6826f4e58c92b5dab6f2e505f954292f08456821311adff7e108af4d99935"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
