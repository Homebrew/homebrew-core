class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "6872b11674abb742d4d2164f0e6920a212c2d55faa6bf729b62bd11b94197ab8"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32f26e7e647860a97d77d86141afdf00104bd4c62205a0cd3769b32c855f62f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c9f0702e42cfc4dd5cb18093c978803d6f1fff252d458dd3e5fdb48d8cf1d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1224110f574fa3f5e7fbfab05c7209a039570df3923e5ae040ec18e608807184"
    sha256 cellar: :any_skip_relocation, sonoma:        "300d68d91cfe48e3c22cd0773ceaa8dffd99e5857affac0adbea8f7196ae9559"
    sha256 cellar: :any_skip_relocation, ventura:       "25710593fd9db2389ec2abe22301998eb05f568cba858c71e0c0ee09acd6ddb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c4a038f0d7fed5cd6af8805488b69f87ca4bed6f23d932b5d5f78af3c1e620"
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
