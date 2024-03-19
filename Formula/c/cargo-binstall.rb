class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "70e1cddb0ad1f0a32544a973246aecf87393bc10ed8acaec20a7eb5e57cc6581"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "322a9075ae2d3167ceeb96da0883d37b57f731ec40d96ed2311abda59e45f76f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "199f3a88719813fc4bdc52357af98a2e9644211c8558b5338cb0e4894668765b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af2dbd9df1b876ae33b15c39c372ec4f6c423cb0912dd2df5fbb893a0ee742bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "aebb471a69f1ff6b026c746949b9d2ac33465ea57af1cb7e6b58ef0937d439ca"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1cb9139206a890acb857c77543273ad9a15637fa435cf67cfd2b7f1b4baa49"
    sha256 cellar: :any_skip_relocation, monterey:       "87da9d9307bfcc7bf23bc6ab1da266bd870884f101d90ad56b601474149dae32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826091e7d9f475a71158aad28ccca991953639440f82445b4f86c1040c9cac92"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
