class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/oxipng/oxipng"
  url "https://github.com/oxipng/oxipng/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "460ccfcdcc9c3877b9f7fae1dfd4f2a3f93d3b2a2af3e3b62ca32b163f923cca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db9a337fddbb8d2153ac22b5a9761298bfbb3b8ec6d6d51085a4586877843977"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "860172692307e908ce2fbef75e7a877a66b1d3dd8d70692108389519ca6a9d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5e927976512c5418e0e34bc29cb29a5b14054cf180881234b6fa802d787e5ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8034f39876c03d3c85d2955ef4bfb26123d021bd0ec85390a5c9b4cbe9515b5b"
    sha256 cellar: :any,                 arm64_linux:       "bcc4caf4f5799b424e2da229f3bb1b1163f6587db9d88a6aaf8716d4a1eb0592"
    sha256 cellar: :any,                 x86_64_linux:      "07babc404b99d6cf41571149878e95edb9457f247bf72327c634722901e4d25c"
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
