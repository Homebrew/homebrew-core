class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.7.tar.gz"
  sha256 "2d2ea147ea75040a9f8e3c0493dfb01bce0b6cf508830293a51861b1ca8d6b7d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "802b2e4a756a552d003f1bc6ee1addd5f4c5aefbd5832a20a97680effbb7bce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad4725895e5bcf80a1fbf2cfccc31e84090e6d75cb49078cd0ca557ce99f9d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8c31dc66c7b611ae98c1b2aa8f9fea4b394f91afac3d609bb072d1fb8f562c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a23c83e57438f38096685d7afe30fe6ee05d69a6ad20bf07118c86a967429e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74983a8d523496ec47fdb3bcfe9b82aff7d054c0075b8ce2c7e0be75b609f968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9c517ffd2d886354c4bd2b9771ab9b1fa44637da82e34f015ac78d4612f077"
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
