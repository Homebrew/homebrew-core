class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.2.tar.gz"
  sha256 "b225a0f3c1331e2ccb3c2661c24cbfde1d162ac8e74a24d80940b5f8ae9d95e4"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12de60bcd4aa8e0cb6e6b843211b9e632a10fd438767ca1e8d34ffd7ee249524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "147dff847bc1275c39f57604cf4bd604c02fe34df81ec03b58e1409d8f9bb548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc7e2c2a6e2ccd70d4905be4fa23ffe7bf7f5aa0906dfb97f888288e80a7dd6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ed34a9070f8ec8c8a900e257a874aaf02bdc1fda74a46695f98b63df677503b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "221c84a18cdd9a04a20e82d3b912c4a1fdf08cedf85fe965cde16f7c288c74cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119b8a58cc1a92ee145706181a8780439707091ec105e1510f81da1b7b5126b8"
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
