class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.4.17.tar.gz"
  sha256 "da9dcc7136882aaaa696a3ffa1bbf980b5c202c561ae992d9ce3e9fb994a021b"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "728f128aa5442ea3a2f2e1702f66212611c61520f515176e59c6aa8f18b8c33c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f095f952798e6d0d2c05ffc54633a2db2687cbfaec9e609702743ef734fe4b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd463ad2bb7124b40d011f81ac9aa5f9e22432fc877a57246f5a0c8781be6ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c434fd950ed2f0697abef33ace8b467cd620e10ea85eceb60e90194ce15157a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed894fd59df287fec064720a5ea18ce9aa626a46c3188bbea698bcd0d708b6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4f5b97ff5936831cc17a5277496e40ada6b4b7a6012ea72ff0c993610c62ac"
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
