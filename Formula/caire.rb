class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.2.tar.gz"
  sha256 "73924c22993baa98ed9310f9c4f7a004b3bf565a3a9b031f003f2d50ba662fda"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4bf1a72e527a85be50fc7c4dfe1af988769fa0b1f197dc0b5db022d771fdf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee33e9e1d7a061cc92236061be8029f75d3acd9395430a2c0af3ff2aeba11eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "33201d8b99664b0dd8ffb137b3c8e9238e39656ac8c588410831db6b60e5019c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8b0c4a234c14498bc4b0b640e4311fb3dae4b9d9086072ba272fab40e5736ae"
    sha256 cellar: :any_skip_relocation, catalina:       "4d13f27b34b359f454e5985d1f82d1604d4eef40a2d6232f080fcdcf6226dada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf239573ebbb1b3466e3743b890d04461b56c58f75903948d67b27489dca480"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    pid = fork do
      system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
            "-width=1", "-height=1", "-perc=1"
      assert_predicate testpath/"test_out.png", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  ensure
    Process.kill("HUP", pid)
  end
end
