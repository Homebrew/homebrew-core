class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.3.tar.gz"
  sha256 "80841c430d3022ef768efe50f8a895239fe8f4d86f3e51a76efc0b5026f13fdc"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14f70b3438845397060eeb951fe97db41389f709acf0f13a954b23e3e3797c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a01b854816989ac5df266cdb211588b87c35bc889ef4960764c932ff4bf995e"
    sha256 cellar: :any_skip_relocation, monterey:       "a483a740c1895b6834e4bbb76c70b92d7711c7568671b7740ca2410ce72c438c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c2faee11e04a2a2a2816f3de11aa700ffbad6d1d1636045a2e3e7edf94117e2"
    sha256 cellar: :any_skip_relocation, catalina:       "f7218ea67bedb743c074e9f2ba1507deea1d752f6d205bb69a66aefb7d579074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec617fa865ca313ca11d9f40680702dd0f3e94b87e4e2af3dabb43e029ee170"
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
