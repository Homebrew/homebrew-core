class KanataTray < Formula
  desc "System tray for kanata keyboard remapper"
  homepage "https://github.com/rszyma/kanata-tray"
  url "https://github.com/rszyma/kanata-tray/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "b7541d686dcabbdbeee4ad78b8eabc2092260be93dc3455a51263f42399eac00"
  license "GPL-3.0-or-later"
  head "https://github.com/rszyma/kanata-tray.git", branch: "main"

  bottle do
    manifest_sha256 "64bf954a639d68df60528b645c818f34dde608b6ec0d0c21944c53af0b000176"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "daeb512b82b3f8821e6ba29fe407e6d540386c5995e886f7d9b844307b5e26ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebb165f640d1eb5fd95d1901b4ff647f04c32d8f4aa8fd9ebb89710884119609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92b91c850fc4bdf541df557f70fba823a303326acb59c0cfd22a96c04dd9566b"
    sha256 cellar: :any,                 arm64_linux:       "d12294ad3b4ec40162add8e5c7112eb2619484ecc86d52467bb6038d9fb25e0e"
    sha256 cellar: :any,                 x86_64_linux:      "004714319bb5eb43f0d6e823649a12875db5d282989d9aa376ae5ee1c99b6f35"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libayatana-appindicator"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = " -X main.buildVersion=#{version} -X main.buildHash=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["KANATA_TRAY_LOG_DIR"] = testpath

    assert_match version.to_s, shell_output("#{bin}/kanata-tray --version 2>&1", 1)

    with_test_process(bin/"kanata-tray") do
      sleep 2
      assert_match "Creating it and populating with the default icons", (testpath/"kanata_tray_lastrun.log").read
    end
  end
end
