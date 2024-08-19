class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "1cc349359c0507be7c8de8f3e9a64b9064f897f8b77fb50979d4726e579e6316"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f355a6f46f05194669376434f65d3610869bd762bd3c2f984eab0c49548277d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4563318eba5c980356cef64c441ee5055c1f2dde538b004e8670f557a3e2b9d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f99ebd10f845fa73a9e5b81fa2f5882092ce405f137e8dee16d5d491123cac"
    sha256 cellar: :any_skip_relocation, sonoma:         "12779abf2a83f1413816db66aef1066bc5d586275509b26e359624b81fffbd91"
    sha256 cellar: :any_skip_relocation, ventura:        "56267105d2153d3cd3dd138d823b8967e8a48722681c7e99f148e0e5e5ce9bce"
    sha256 cellar: :any_skip_relocation, monterey:       "e73e0c12044e9517ef1430b44b82372c2ce57d3a4655a5cf304a16f9b2da9ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c988656f673fec41478dfa3c54a652f086a38ee76a867a8e515d84058bd5ae96"
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
