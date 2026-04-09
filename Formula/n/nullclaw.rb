class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.4.7.tar.gz"
  sha256 "db3a86db3cfe08a146a9fa8cb7f66ec4321d4c0655329ace23a50385fd71cf20"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4eb8af7c523d1724fed44b95ed8aab1b0523b2f58e0c0c3aa37ee5c55a3d360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0455d4f49283dc78732e9442de26ac659ab299bb4e34504f9d66018644e84ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d31e6fba81345384dfd1088eafdb5fe81f0af4e533296211a030a74c81bb33d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e432917eee8ed8676cc588142a5c698c05cb3d6798a9c416e5358b599fd13841"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4ffe217061310ec4b0cdc5af6cc9eadbdbc9378a07b891ebbbeee52803a24a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab65a36ac869348211a0a937d298ea4b88111d412e365d993cc3bcf45d5f65a6"
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
