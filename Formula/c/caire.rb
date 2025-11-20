class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d63c5edff4f12bc14e787c0a8f3acb456119e1a03d4bd8bfcf70114abd44f941"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "413a46b531e0f7f0fd954c70d65ca5158a8b01ae7748b56859eb07cf4eb97d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa63b8d899dde73b2137eb9bf77b51e970eaf124523887bb6db25a40fb8c6ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a7667e7b36e996206c910087a5e667945d1bf7a111fd033e2934c915303237"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e03f494a7f6fa1411aa724859f27f555f3ba850d5b0a3f9dc76810e314e43a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d79acf65528d8c7b30ef658380fac4d0c9cd6cf8ebdfe2a75d6e1e9ef2fb87"
    sha256 cellar: :any_skip_relocation, ventura:       "93d0172823e84beee86f213dfd1738de678668778bfd48d6ece7a73892cd8070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3054ab90f891eee21ac084564e33c4b280c99870f66bae2beb1f198edd665f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6d577c0674569e1ec5951618888fff00373551779eeacbfa2712b95fe936d2"
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

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for gioui.org/internal/vk)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    pid = fork do
      system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
            "-width=1", "-height=1", "-perc=1"
      assert_path_exists testpath/"test_out.png"
    end

    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  ensure
    Process.kill("HUP", pid)
  end
end
