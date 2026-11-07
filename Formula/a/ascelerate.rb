class Ascelerate < Formula
  desc "Command-line tool for the App Store Connect API"
  homepage "https://ascelerate.dev"
  url "https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "cbbb67ed4a41eb8b912b27816a5b2a111a5b106f41212de774418aeebef2463e"
  license "MIT"
  head "https://github.com/keremerkan/ascelerate.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "cac72eb8f5cded47fc0a28ea0a05fa7f4b37447c7257a89801e8a7eca42b7aae"
    sha256 arm64_tahoe:       "7391b55ef23c9347aa9e96e46c3120f468e40dd275c740af49228d3861ee815d"
    sha256 arm64_sequoia:     "804b59344b03f60fe787bfa2d54bf2a240c72b9a58eb06b58a70023497aff09b"
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
