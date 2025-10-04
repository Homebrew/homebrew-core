class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "0e3b6b34271b78f0cdbd0851a6c7b37e1b4562d546f4f93124a7c7c038b2315f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7848829328461e664a481412e65a757cd8afd812f6a5fd3e7aabe3ad97846ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd41dd2db1d29bf4f2c9b04a8eba05d6989b90e3dc93bd9eb4fdd775b28b8a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "111fad02160c367d7c97beafb94c88128355b67536836de8ff1c4bbf3984a604"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7abe100a92a43c73916f395495e1f1afce41ee1c5a9b2cf1f00ca70ffb1f6fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa683dc8a5589631e0cffd6d5b162272fda2e864270cf559afcf3dae2b90263e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84fa98dcf3ef131f628b6d16018bbc67771f194ae7f69dda9e6a132cf9c2a893"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_path_exists testpath/"_site/index.html"
  end
end
