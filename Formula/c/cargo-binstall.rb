class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "04c373890842eca59146398f319650e8a16632d497fee108132f597089505c13"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4daf4662ade31ad872e70ecafdfcdba1bef0ec9bc10b18371335683ab3281e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fede77cd45423c1378a35907c7c8b161c6ab25847ae23d54d65ede1112ed8949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2770fe3132afdcef618d0d9146f9087e5425356a066eea2178bb823825361d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3524935dbcf003adeac48a155722a696649e976201b69121fcb4bc41f2de9e"
    sha256 cellar: :any_skip_relocation, ventura:       "e5f4b7fc830cfd7b8d585555c6e8095d6d1ac7094812825ab3daf25395ab5a41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ebd6dca5d46ccae3ad4e6b66416a69b57cc1522e16cb0c1368eb56de288db2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afd411c700b63581e2be21e32fee46e9ad507a3f756cb0160676241cfc21348"
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
