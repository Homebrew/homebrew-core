class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "f96ba30a65888aaa48e7539512b734f88b6bdd03b40e06a765cc298087ef4618"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f46e9609b8cc0e9fba8a4ba312adc7c02e7ee511669f6f774f5c8259de7ad59d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f17b02af8cd752114b3b2cf1bd712414aa983052a9ff4d9e9a59df68945438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c7121cd2f5db04f7284fe2c2fad6836a666a35af6da721b76cd014ec81043b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b8e7fb3e60ce1b7fbd30ede5eece82f4344a64a141903115bdb0569f8e5b672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff433e526eaea16fff88648b84bda589bf5795d359cd046278f72341c4a86e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f78dd335307767c0d74a5a78ac0172e31d57c7175e9784d172bb748e080a5da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
