class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "0325fad3a856a52937a397befc7f5fbe32076db991f19cdc8cd656367728cc1c"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f61129d70cd9b7d12437ec9d54d0a896eb399f219992ac1974e16f7a2dccb6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743590b7871d991c487734a9259e1eae794683e29c4b26adf50c5359735f7385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c41d7e630d3d34720f8a114b36c84abf2dce833050a60afa65de88398dddc3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c61f1da1a9b9978c9ff351cf0ae89e60fd4739949371a737b6b4c5d8b3367a8"
    sha256 cellar: :any,                 x86_64_linux:  "e5a1d41f9950c6be51f3be3b4cdef0b9f252874e18199f7ee658957ccf426f4e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
