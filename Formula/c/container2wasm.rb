class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "a6846c11d8ebab255f530d70241fa28e26ce9afff5cd6a727d0fd33037d10970"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f04bbb7dd642539390da873a58e018235050314711e037a4481efbab7e08009"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f04bbb7dd642539390da873a58e018235050314711e037a4481efbab7e08009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f04bbb7dd642539390da873a58e018235050314711e037a4481efbab7e08009"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8b701ad561cb47a6ca140ddf1ae589ba2fec398cf4bc2b0baeca78e1ea901f3"
    sha256 cellar: :any,                 x86_64_linux:      "18ee429982aeeef0fd9d25b3cd4076937aaf2f9f95946ca5327b27f9407c7206"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/container2wasm/container2wasm/version.Version=#{version}"

    %w[c2w c2w-net].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2w --version")
    assert_match "FROM wasi-$TARGETARCH", shell_output("#{bin}/c2w --show-dockerfile")
  end
end
