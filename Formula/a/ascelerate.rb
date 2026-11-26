class Ascelerate < Formula
  desc "Command-line tool for the App Store Connect API"
  homepage "https://ascelerate.dev"
  url "https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "d92047237d6ce0869553b2a899dd5c4aa30c1acfd00192c6bd42bffa04eae518"
  license "MIT"
  head "https://github.com/keremerkan/ascelerate.git", branch: "main"

  bottle do
    manifest_sha256 "ebfb6af473ca452f8fb4117ae37de4aa0c859df5677068d42f11d349cd8ff6eb"
    sha256 arm64_golden_gate: "73db3e9dd1835f7f78199c926165b08c39a06caf129905cc26e9aef930978fb7"
    sha256 arm64_tahoe:       "3e7b19404b57aeb4eb09b67bab577c149716077528beef8a50fe5d947a02e9c7"
    sha256 arm64_sequoia:     "a9b844aec16468ef2f18dca70d23a61436150fc3ae082401ee2c3bf4b7c15900"
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
