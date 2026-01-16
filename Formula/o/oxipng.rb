class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/oxipng/oxipng"
  url "https://github.com/oxipng/oxipng/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "c834f87cab52c621b113dd6ac718d591638043471705b0c4fa4aa958796e0051"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebf46bc85c5ad6d6d63f8ae1d61de1ab0604ce2c5975e2f3a2907e1544cc7097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a2b9a0684635b79758f2e7468347d4b09d4fc3aaf00d44e02e215e68042aa05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf327db6522d0d984c820968262443f4a2833c5dd2b32d7c534f220b8f03c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "132e413389174f87c78854611e3a15ee486d83713bcc40c75d761df96e24ea4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3adab467f862e6585bef7a698ff46b3d29f1f69edf1607a01034e7eb7a845e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289df09536c2c33ed08aad19c64db4a83dcac3c8925243f878ce75961d6c3eca"
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
