class Lsr < Formula
  desc "Ls but with io_uring"
  homepage "https://tangled.sh/@rockorager.dev/lsr"
  url "https://tangled.sh/@rockorager.dev/lsr",
      tag:      "v1.0.0",
      revision: "9bfcae0be1d3ee2db176bb8001c0f46650484249"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee4d7eca5ce1db999d5e5efa67c6e8f5b9f5f681d17ec27a5212e1a8ef4c6b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1684d5db5fd99d451a80034ac2168b7e5ef5cb22a284ae9d9c587a7fa8f435bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a27d7bc4981b7303039e18075037a0c87615c70f2cc7e63937b08a6593bed38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "080c3bbf7a9ec1cef93b734868fac72f922ab66b5c9286a36fdb61d89ffb260a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e98cfe0a45ebdc07e08b3e06157612110df9824170d8a1eae573836b70bc98c"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f894defb6f85dfb7362814e325ccaabebfd0914d0a82c63a219940c74ae6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "071775094aec0e406a570dafb3d15fc0515c3277f1136ea4424cbffd1b833e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0044a4cca23cb76a32c0095cee321c50d049007a608ae54155268b0ac30a1213"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-02-19", because: "does not build with Zig >= 0.15"

  depends_on "zig@0.14" => :build # https://tangled.sh/@rockorager.dev/lsr/issues/13

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args(release_mode: :small)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsr --version")

    touch "test.txt"
    if OS.linux?
      # sudo required
      assert_match "error: PermissionDenied", shell_output("#{bin}/lsr 2>&1", 1)
    else
      assert_match "test.txt", shell_output(bin/"lsr")
    end
  end
end
