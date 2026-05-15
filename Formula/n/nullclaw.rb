class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.5.4.tar.gz"
  sha256 "55ef8083bf9a242c19cc62f5f1384261d0e1b943bcc69ee9697a784e55522c29"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50df356aa8cdedfe9cbe62072019a294d1e1b9d83b28f03617477f018f2b3b58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c826052a91d11d2f7305b3f6ea9da14db7b25f61733de85eaf484c18c7a47e53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce60a2f8e764f81d8b4078bf179efbada3dd590f983893bc826ca03e162b89a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ab974567151eae6e0abefb5441ae2f08f28a33c4414173e9783f1113e8dd87b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d1b86847836bd4dbc123acf122aeee4df1349e252ab0d25358abc59ac3dc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1848f6c253800a4c4ddc80929c92556a44419632cf06030227c062b1dc44de1"
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
