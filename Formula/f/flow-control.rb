class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.7.2",
      revision: "af7c97acb9579f76a237a52e3104b1639dd24fbd"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f08e640306926634db164cab8993ee3057a97470ea97b9a8085bbd264d926a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62828763a413966a8e4e34539ed9efe2477ed85869ad02f0d4b06b19f1410f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59edb98254f173748c99342519f678223fc90abcbe105a063a5893eeaed9be32"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f793e29a04636d851294a84c93df1087e11240b24f41bed2bd78ba81812302d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03827eba7cbd5265192175674b32a4efcb28b856c66fe61a721534289c600a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23ea757119c328bc9fc880ec1df320cdead86f29ba3f58d3787f00efe7cd81b5"
  end

  depends_on "zig" => :build

  def install
    # Avoid an error when the git repository is detached from HEAD
    inreplace "build.zig",
              /const describe_base_commit_ = try (.*);/,
              "const describe_base_commit_ = \\1 catch \"\";"

    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    # Do not use `std_zig_args` or `--release=` flag here
    # as after using it all targets are installed into directories with
    # names like `<os>-<arch>-release` instead of `bin`
    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseFast
      --summary all
    ]
    args << "-Dcpu=#{cpu}" if build.bottle?
    args << "-fno-rosetta" if OS.mac? && Hardware::CPU.intel?

    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow --version")
    assert_match "Flow Control: a programmer's text editor", shell_output("#{bin}/flow --help")

    # flow-control is a tui application
    system bin/"flow", "--list-languages"
  end
end
