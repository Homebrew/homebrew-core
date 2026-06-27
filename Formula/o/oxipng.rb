class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/oxipng/oxipng"
  url "https://github.com/oxipng/oxipng/archive/refs/tags/v10.1.1.tar.gz"
  sha256 "ce19b1f060d586ceb3ea682f27d00e41675ec4093d8ac200a61ccd9d967d0999"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52431e2e7f4d20f8b7562197f639076b33743c421a60b0d20e0169b562eda94a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad379f9ff45cdb9f41d69b45d0bb539786a862488c16b4597c957b07059a7908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5271f06c822a35a46b730bf92e9416ffb1f87fb99977d02231f0cc1e3ed625e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ae6c5a1881f078c7c46615e0ea6b23731ba1436fef46150298c95a6cbf01831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49f48ea437f4e369e32698717833d8ccbe7b6bb8d018c9f358e7d5d7f3c214c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a6642666b1e3b655c6fc6c02bd0c9be07fb2798d8b8bd8447499417acbc451"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run",
           "--manifest-path", "xtask/Cargo.toml",
           "--jobs", ENV.make_jobs.to_s,
           "--locked", "--", "mangen"

    man1.install "target/xtask/mangen/manpages/oxipng.1"
  end

  test do
    system bin/"oxipng", "--dry-run", test_fixtures("test.png")
  end
end
