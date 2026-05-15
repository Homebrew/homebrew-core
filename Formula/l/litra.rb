class Litra < Formula
  desc "Control Logitech Litra lights from the command-line"
  homepage "https://github.com/timrogers/litra-rs"
  url "https://github.com/timrogers/litra-rs/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "18b998c9d4d7d4db515765852d667fcb24b9ed84ba917d2d8385bee3eb59cfa6"
  license "MIT"
  head "https://github.com/timrogers/litra-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36fb6a68b593db3540bb1f56f0a93e78f352037c74087c895866a5b3b19c1a54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47760a0c05a934fec198bea24f521151e291bd37d1e7fcc32cffefc6aa0fe10c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9a58f9d9d86cdb5c782f87c248f2c4af3424f698414cc369fcde628e5ba932"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebe982baddbefa1ffd6ce03227526560d8e90672d98471e09760f899bc76e477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49d0cb09b0d496fae5fbe1661e5ad3809d440740070404231ecd8c07c3e7b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef3fbf28dfb425e767db30e4402f5ecd743b3ac8265c15f997a6205701038b6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "hidapi"
  end

  def install
    # Update to use system hidapi for linux build, upstream pr, https://github.com/timrogers/litra-rs/pull/210
    if OS.linux?
      inreplace "Cargo.toml",
                /^(\s*hidapi\s*=\s*)"([^"]+)"\s*$/,
                '\1{ version = "\2", default-features = false, features = ["linux-shared-hidraw"] }'
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litra --version")
    assert_match "No Logitech Litra devices found", shell_output("#{bin}/litra devices")
  end
end
