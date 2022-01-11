class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.1.tar.gz"
  sha256 "2676d646c4a9b75d3734ac49e4c27d62008bd889aad0297874d34906a526e8cc"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cefb76d3d2b0d5e90605438e1e8407f5ea1eb16804e56cc0d4b51e3361c540e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f9b05ed70dad94f07dd436aa8c63d4b67ddc257c7d522eeb3889c22e48db5f7"
    sha256 cellar: :any_skip_relocation, monterey:       "b677601751fe877ca4205bd2717ddd91569cc8378cd074577c28445b3cf3bfa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a36b307f84c3bf5600e9cbac9bb9ce9ecd9a5f59209bde80a4f9b70f2509b1ff"
    sha256 cellar: :any_skip_relocation, catalina:       "1b2c50e93412788c9c4764e324f66245644479b2490b0bb2112791980f82fc18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00dc9baa5240bf8b303a12d408c7eb92ea7b886873dacd0f292ff8c89520db0a"
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
