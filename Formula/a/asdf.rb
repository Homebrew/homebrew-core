class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "49f47b5b5255c6f29384f7d403d6c27bae9ce9944a4ff9334c67987d4b6c97b4"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02a5111019f00e7f2bb4ebc8caedcf2385892e9df1814676574cea32bd61bd47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a5111019f00e7f2bb4ebc8caedcf2385892e9df1814676574cea32bd61bd47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a5111019f00e7f2bb4ebc8caedcf2385892e9df1814676574cea32bd61bd47"
    sha256 cellar: :any_skip_relocation, sonoma:        "38941222b8c7f94ab50dd4830f3564cfa6685de31b7b2462f809214c977ccf93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ba1c5cbbfe833aa3dd08b2f6aa651534a3e0f90ff063a8cd1f11bc78a9a565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6e7c59d07c598e7b70c0f5ddf29f0a1fe4f9d4f34c28c16d7ddd79ba44e172"
  end

  depends_on "go" => :build

  def install
    # fix https://github.com/asdf-vm/asdf/issues/1992
    # relates to https://github.com/Homebrew/homebrew-core/issues/163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
