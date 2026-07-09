class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "4216e148c88588924f4026d8359be35f5c861967ab8e55a733bb879cdca678e8"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1118f94154c26d2ce098ba8481631cd43db3fe12bd282c607ae7fa78c16165a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1118f94154c26d2ce098ba8481631cd43db3fe12bd282c607ae7fa78c16165a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1118f94154c26d2ce098ba8481631cd43db3fe12bd282c607ae7fa78c16165a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d20aab2ad4a9e7a728406c6854cbc60020dbcc7167a0f9b55c3d47de2114b734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa11094c02860d51e340dc934db3a61a6e9b7a89bcb027a0c17c2886315dd065"
    sha256 cellar: :any,                 x86_64_linux:  "21e5c39ec7555e99f5b4905c3baa1ecdb8c3ca772062abf4d14610967926a47f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ktock/container2wasm/version.Version=#{version}"

    %w[c2w c2w-net].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2w --version")
    assert_match "FROM wasi-$TARGETARCH", shell_output("#{bin}/c2w --show-dockerfile")
  end
end
