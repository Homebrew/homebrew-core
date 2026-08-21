class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/oxipng/oxipng"
  url "https://github.com/oxipng/oxipng/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "0d0da5f245ed3a669bce63d3ca368d476bae67b0014a927c00df912c9d964a44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76dcfd94093d2e1925f8c9d10bd723e7ea26d8b6705a449387db0fc2e51c8960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6ca74906c369494ca81243ce19e9bca99c082745cadc6cd66a5fef3fbb8869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e21a2040e71fd256377c68b96b997527b3cbe678f32e9cd076301dfef0a6fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "111b22ddb0826887696cb461f5b27f549f5d2f1a70d37b98aeda453fe566c3e2"
    sha256 cellar: :any,                 arm64_linux:   "3e56f2e6eb1e12a53debb1102400d77ad78da19ae07a0e496b24ff2d159e3d2f"
    sha256 cellar: :any,                 x86_64_linux:  "e719f3296949ebddf62b0d66d35245ebd581173899298d279e3941d312df429e"
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
