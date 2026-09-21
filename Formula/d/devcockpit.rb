class Devcockpit < Formula
  desc "TUI system monitor for Apple Silicon"
  homepage "https://devcockpit.app/"
  url "https://github.com/caioricciuti/dev-cockpit/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "5f0c72cd82ce06b166ad92810d096507c9575350af058734c3c010408cf0e87c"
  license "GPL-3.0-only"
  head "https://github.com/caioricciuti/dev-cockpit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c12a38fb9fe8b0cd21abae41ff99523b00e4028a54d92a9bcf938b48e9b43fbc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d289d6a1f9a8e61492837edcbcf4276eb7d88d0f5ba5ab6321eab4f4741a0fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "503d130e526e7dc94e1e45d9978ffbb838ca040eda24dd5b106869a74ed92008"
    sha256 cellar: :any,                 arm64_linux:       "4b7d4ddb69b7df02f9748e5fae09f1604c49a81a6b44af82a44d82afbe211d85"
    sha256 cellar: :any,                 x86_64_linux:      "e52d378982ede33463cfbc438c21138c5f058e1b5fdff2650fb3ef3a3a6a954d"
  end

  depends_on "go" => :build

  on_macos do
    depends_on arch: :arm64
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "app"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", "-C", "app", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/devcockpit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcockpit --version")
    assert_match "Log file location:", shell_output("#{bin}/devcockpit --logs")
  end
end
