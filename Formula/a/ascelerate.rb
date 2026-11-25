class Ascelerate < Formula
  desc "Command-line tool for the App Store Connect API"
  homepage "https://ascelerate.dev"
  url "https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "6b906a3d522c215b346dfd65a15913fc79637478a7dcbfe16b1c741936b13048"
  license "MIT"
  head "https://github.com/keremerkan/ascelerate.git", branch: "main"

  bottle do
    manifest_sha256 "ba2eb05bd693a723c86273e680510fbfc10129854bd59fd104137e65f987e1df"
    sha256 arm64_golden_gate: "a510adbb16092734b47b0f8dbd9e65f9bdf377d8c1dd188cc6a56ffc2056c80b"
    sha256 arm64_tahoe:       "68aa2184f74701105249fe05fb0b98b6b9ccf64c432984826c9054cb8a181805"
    sha256 arm64_sequoia:     "5556a855ac4307ab2deecabd0614d5dd7bf49db2d6f8acb885d0da65cc2221a8"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    # The generated App Store Connect client is one large module: optimizing it takes about 17 GB
    # of compiler memory, without optimization about 9 GB. The commands spend their time on the
    # network, so the unoptimized build runs as fast.
    system "swift", "build", *std_swift_args, "--product", "ascelerate", "-Xswiftc", "-Onone"
    bin.install ".build/release/ascelerate"
    generate_completions_from_executable(bin/"ascelerate", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ascelerate version")
    assert_match "No configuration found", shell_output("#{bin}/ascelerate apps list 2>&1", 1)

    system bin/"ascelerate", "screenshot", "create-helper", "-o", testpath/"ScreenshotHelper.swift", "-y"
    assert_match "ScreenshotHelperVersion", (testpath/"ScreenshotHelper.swift").read
  end
end
