class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.4.9.tar.gz"
  sha256 "aa07f54294dc7bf68be4290626100c2166cded4165fc075055f4f0ee796350cf"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23a5e3f8a1f4daf2ac6c8ce5e072aeeaa13d87d2b14633ad76d35cdc375d0017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2304067fde64e933220049b343d4a5e072742b70626bc674c0d81d6c1fedd2dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ce19c9d9d7d9110ca4a8b9df692567ca412cde90de589f78eb1d0bbabb2913"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbf9e2db1155f6e0f5475434309ec0c95caf13ea29294d7219adb0ade697fec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bbf4c618c8389ea53b5c0cf4cd0aba1ccf27310b010dccd98a708e51ebc8068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3207e120165bfbc3933235cb27a1d7d720e89481b8453b521f4744416470c84f"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = ["-Dversion=#{version}"]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  service do
    run [opt_bin/"nullclaw", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullclaw --version")

    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
  end
end
