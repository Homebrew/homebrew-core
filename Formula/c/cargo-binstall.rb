class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "689a84e2041c36ad23e279da49cf91d5414895e06be875ff9b7ad84313d5306d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d22c2fe0397e440db0f813b49d0426206b3a5c56d566c2c0ddd48df8b91d5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f49fafec755df6262a0d8868ef87e016ee05ffc539c93b9950eea78a1e4d697d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f43d74dbecedfcc43bb70b6b5c093d347ef4e3d570886a363ef5c167843cf43f"
    sha256 cellar: :any_skip_relocation, sonoma:        "307cfdfeca37a3915e7f4613a6dcf46bb15cfe87b6ae5d379dd2c8c06eecfa0b"
    sha256 cellar: :any_skip_relocation, ventura:       "5ac6e9e36cbe1656bdc698588dcef1da68dbe6f9a95676f4a8bee05e6c496711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "644ced87d9abfac417986f2eeb952561016e3fa455320acaac229b2024c5ad1f"
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
