class Devcockpit < Formula
  desc "TUI system monitor for Apple Silicon"
  homepage "https://devcockpit.app/"
  url "https://github.com/caioricciuti/dev-cockpit/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "a1ce6d16d46da379d88ca579f24d9d16c542b047c6dd3005637c2d45cf7c49e7"
  license "GPL-3.0-only"
  head "https://github.com/caioricciuti/dev-cockpit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a25af8b7c4bd01d8a57740d3cde4bf7d414875fabee82094bc775ffc2a15e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f144344e18802921f1086c3e12a4fc2c36d5acfe5e10d00b18d488978d8a3750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "156101ae088f57254b78ef3d8e48f94da079eedf3e7a9d04713aa8e727d56532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a78c8abb5c2445639be83fe271a6cbc0d2888272bca1554826de924a166e1b3e"
  end

  depends_on "go" => :build
  depends_on arch: :arm64

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    cd "app" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/devcockpit"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcockpit --version")
    assert_match "Log file location:", shell_output("#{bin}/devcockpit --logs")
  end
end
