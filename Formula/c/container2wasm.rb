class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "a6846c11d8ebab255f530d70241fa28e26ce9afff5cd6a727d0fd33037d10970"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6aa905bdbd283e24f17b43ab7d595606645400cbd087f5124170e435c21e566c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1118f94154c26d2ce098ba8481631cd43db3fe12bd282c607ae7fa78c16165a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1118f94154c26d2ce098ba8481631cd43db3fe12bd282c607ae7fa78c16165a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1118f94154c26d2ce098ba8481631cd43db3fe12bd282c607ae7fa78c16165a5"
    sha256 cellar: :any_skip_relocation, sonoma:            "d20aab2ad4a9e7a728406c6854cbc60020dbcc7167a0f9b55c3d47de2114b734"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa11094c02860d51e340dc934db3a61a6e9b7a89bcb027a0c17c2886315dd065"
    sha256 cellar: :any,                 x86_64_linux:      "21e5c39ec7555e99f5b4905c3baa1ecdb8c3ca772062abf4d14610967926a47f"
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
