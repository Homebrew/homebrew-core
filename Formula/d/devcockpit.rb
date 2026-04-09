class Devcockpit < Formula
  desc "TUI system monitor for Apple Silicon"
  homepage "https://devcockpit.app/"
  url "https://github.com/caioricciuti/dev-cockpit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c839630c5ef7aa29c9ee90af63fb504a540dcd7f1f32142921b31e37a0b46597"
  license "GPL-3.0-only"
  head "https://github.com/caioricciuti/dev-cockpit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84aa9795175f02e7ee87cb475e1f1ba2568de55cb39a5c2fbda936ae35d667f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2660686959db332f0ee1b6df512630cb2f6b72cc36f2f0e0cc96836c004bf745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516321e72023a3dced4f7384ff512fb0810cc3ee8c9c9185ad58cccd41db1f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f1f7aa25a859192d62b0c5b730c74fd3a57b5c968ba1b5adf3f0b4c59631642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4aeb14df78176406364c89ceaafec47e892053ffd8a6ae107bc5d38de12abd5"
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
