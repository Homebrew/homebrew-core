class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/1.6.2.tar.gz"
  sha256 "218bdd9d23d7b72f86372c8e496d0df8447d971db828291c64a8a33d381eea3f"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b7436f9a42408488bd0b5333c517ac53a6927a5ba399c89f0bc2ce02d83c745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b99c8c8e2519cfe19ddb8f5d81ec0f7189f0e004c649a83a42c559c36dfe1ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08692920d0962c8f429fb34746579fdcfe8ba1a9139c46ed15b1dbdfec36d412"
    sha256 cellar: :any_skip_relocation, sonoma:        "405b392bcfde5e8d1b2392f55e8c29ac65f6b5451159005bc91561d52b595f85"
    sha256 cellar: :any_skip_relocation, ventura:       "e8c696430b696ae2797b8062b52135c1331b0a926e70ab8794258e5962897005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "441ec8cf1b6584d51a503c1136c806e8948638330c09968e66bb28a534eac559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81c78ad222644c15e629418dc04ea2e9179da733eaee6cb9c57f4fda7ba3ff2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end
