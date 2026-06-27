class Devcockpit < Formula
  desc "TUI system monitor for Apple Silicon"
  homepage "https://devcockpit.app/"
  url "https://github.com/caioricciuti/dev-cockpit/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "feb16115caf94b63b71a5c86ab47b10bee5009207790c99df52443fe4cdd4873"
  license "GPL-3.0-only"
  head "https://github.com/caioricciuti/dev-cockpit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c219068bdf25afb8b35eec889ca9904a71bab68eb877d74037a1bd53f0a7f443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba82bc26988600c8291347d23446a3aa3ac854f12a12059d47a5dd1b47676686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b27277a81e21bb38aa937dada422adbad94ed6ea91eab3e34cb7981d619111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa8f5a921bb8f92fe91226b0fba5b679ab9ba28e8832140bfd70794ead6f8bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4501f7e77eababad97ccc88b68baaf3f93aae146bbbd5409669c48bc201512"
  end

  depends_on "go" => :build
  on_macos do
    depends_on arch: :arm64
  end

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
