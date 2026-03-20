class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.18.tar.gz"
  sha256 "981eaea91d2f33f506f737588ee23765e9867273ca190b3c5a0335983d133c0d"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37809b1742a8e6702a439d903208feb837a0a04af5ef45a083748913bb7a30a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2ec07245f369662461ef8d7f155436f1b2e5b0ded5183be2d4084fbfafeb55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d42b49ea233d3bfb5ab6f7838391a25d1445cd5f4b3af2a5c3ceca69a89c5d72"
    sha256 cellar: :any_skip_relocation, sonoma:        "39a353fd2477641f932440b79acbba9b7696cd68102a8da1e9fe2e5ee8e4af7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c573c90d9568fd1d8c4cac489bf22759a91270e3e7c032f024c919cbd21688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ffe23da0accc35db0da409f51fb387b0bde5554de717e80e8fb9095ecf0814"
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
