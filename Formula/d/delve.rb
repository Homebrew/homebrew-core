class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "fe6f0d97c233d4f0f1ed422c11508cc57c14e9e0915f9a258f1912c46824cbfb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85425c0d9ce8b4061157082e4c347bb61453e6b90f9f51ec389840962cd5084f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6f29b39ddb94d0e55dab7596d95cd6fd1f26d3d92929b3adc5a877f2f7314a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41aaab4925b5044f9b1fa050f96dbc2ebcb580e0e45df09cfb9719bbc24d947a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a70496bf249003a7640bcbd9e901e433e2bbfe8dc810f634924e53c1d1eb6555"
    sha256 cellar: :any_skip_relocation, ventura:        "3e24f27db25680b1a37d0b91231c1e0598dcbc22d73e97d8a2bdca8f0df38718"
    sha256 cellar: :any_skip_relocation, monterey:       "7f70e590ec46fe363ded20f6da3804eef833c89bf0ae850221631f6980c92930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60de7fb88ff43bf813393c5357ffda720ac8100694b7f3d57f1e5857ec30c9b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
