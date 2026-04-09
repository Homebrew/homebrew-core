class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.9.2.tar.gz"
  sha256 "7c8dfec5f56f5e5c0aa2b5e8bab10d933aeab35d1033582872ebec9567538eed"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25a4c4ae497fe3896f778ec1cacc16c1234c39b3ba9e1f49352bd1fdd503d499"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3178c11154aafdfc4debca557675f12346743e0a3bd8ac2491d121aeecf0f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b3399a824c8624496c7dd5a6c7adf737ab68fdc090e1f41a259a9a0a9205a81"
    sha256 cellar: :any_skip_relocation, sonoma:        "e05cd074dc946b2c7b42e57308d60b7df6dfdcf89a2add14fcc7af7afef04981"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba7374b51698c9aec87693961aa9b1b8695f4a41e7fe620d05696df0c209e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ae0fbc6e4a9887859496fe03dc27b6cb7a29ec3071f8b10e1ce6882d4db7df"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars", "--no-module", "--skip-proto"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
