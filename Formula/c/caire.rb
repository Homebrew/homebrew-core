class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "98fd9cd213b2e08abd5e9542b3149dfcb67827c8dc21fab9d3deabe1575537fe"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99f6434b982cdf099a8b29957d1e586851fc19c87c6c05de6100fc2d9335b295"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e395c6bcbbaea4139779f6b3ecb1291588abfed80349dea13a40c1d7214a969f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89aaf1ceb434d86617f9395dde2af02de81c5665218520d6b87a7617b06cf451"
    sha256 cellar: :any,                 arm64_linux:       "68570fdaa64dff88ffb6eca4702912bdb9f85d0ff26785527bb2d6a466522cec"
    sha256 cellar: :any,                 x86_64_linux:      "6d540e0940711294949d1fe943d910c78f95a97b42c5cd6767064507ff95f2e7"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for gioui.org/internal/vk)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
                        "-width=1", "-height=1", "-perc=1", "-preview=false"
    assert_path_exists testpath/"test_out.png"
    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  end
end
