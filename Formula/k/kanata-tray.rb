class KanataTray < Formula
  desc "System tray for kanata keyboard remapper"
  homepage "https://github.com/rszyma/kanata-tray"
  url "https://github.com/rszyma/kanata-tray/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "18d17493d20f6a06db31131c41059d2a8224494479fdf98498eb76c0fab70885"
  license "GPL-3.0-or-later"
  head "https://github.com/rszyma/kanata-tray.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb526f18706af690003f2ed01864946f9d571f6c4806b283686980a640482ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7395f0834cc4e3a0e8fea0f0017e8769a753f58a60287747c5c4b85993cb2633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310cc724d28ccf0df5203fbe061d1e109cafedf36d68c8120e96737ff708ef27"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab65e1afa544494a2d88f75b534a1ee92b991a9dea378960811eaa2ed28f9c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3f913d959bd3b930477eeab58ab7b60b98e760c17015cd9c02c74e709ef87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df26679273f6a01d075bdc7d46b725c1a439f3060a94d3ce4b80f77e69ac38ac"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libayatana-appindicator"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildHash=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["KANATA_TRAY_LOG_DIR"] = testpath

    assert_match version.to_s, shell_output("#{bin}/kanata-tray --version 2>&1", 1)

    pid = spawn bin/"kanata-tray"
    sleep 2
    assert_match "Creating it and populating with the default icons", (testpath/"kanata_tray_lastrun.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
