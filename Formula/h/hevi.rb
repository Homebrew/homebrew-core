class Hevi < Formula
  desc "Hex viewer"
  homepage "https://github.com/Arnau478/hevi"
  url "https://github.com/Arnau478/hevi/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d1c444301c65910b171541f1e3d1445cc3ff003dfc8218b976982f80bccd9ee0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af71a0d595ed48d139c93e8f4ef5a59edea2309afeddf280c5408ba532d470f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135aef044ae02eb3898d410284c9ca8e75289effcef3dd15bc56f7a4df50f1e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e9597a6ff6d8eeac1df5ad0bd524a8b2a1998af819df0dc5d2b2ff8f6037a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "c023afee5920d4732b9a9dd8d85e0c2922a877cb51b288901ea93bbb90897b37"
    sha256 cellar: :any_skip_relocation, ventura:       "7ad8ac2263159c788705564b0a17d3f9052f237db3efffcd1e68f089314a4006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a58cbce9389c32d13ddf68be6a62b89113000d5ae6f82711174b90cf63174e"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hevi --version 2>&1")
    assert_match "00000000", shell_output("#{bin}/hevi #{test_fixtures("test.pdf")}")
  end
end
