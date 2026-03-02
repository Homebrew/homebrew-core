class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.github.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.2.tar.gz"
  sha256 "b225a0f3c1331e2ccb3c2661c24cbfde1d162ac8e74a24d80940b5f8ae9d95e4"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "616bdb9885d8efc515046d18ca11e145be30b62dadcdbb7a700d93252900527a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e500516c3ba990546264a57632b8cdd937bf6af5a17c81b97810c5a7fb07666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eeb5ebd20b60cd72cf843e455eab576cd4eb1c1d1d0f23588ae45db69b3fd26"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc4f2151a3514ecdf57c522726064d862648b8d4bc8d8c5c19e0f4c2f96fb31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48d7ab5d5a18fd557a8d7265352b92584e62211aede66c84e7b1786c57e49e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6642a7659c3b4f9b8ca30810dcb11fe02931cfd1626066abbf2c53ea51712b1d"
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
