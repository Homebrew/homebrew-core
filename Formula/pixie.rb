class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.7.16",
      revision: "131962699cf7581f4ed73b643c37517db8f4d777"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8cd15e050c5d14d5540b2ea3035b97ef54b7c5bc4567a231ec402576bc46a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99207541af3fd0a6020c9ea20daa41feb57efcb766314c80a542c360a0b1c9ec"
    sha256 cellar: :any_skip_relocation, monterey:       "1a822aa405373b2c71f575b5e91a8b09ab82258c4b73689c9b77e5691dd48ae6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e073ca167f260aaba8d8ec073813e6ab501a522599454de8f045bce63aa963d5"
    sha256 cellar: :any_skip_relocation, catalina:       "9aecee5da4da2c541bc29595ef9eae7616d29dd37b199fc23c4129d96100a8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ceabc505f13445528341c9e75b2fc6da8c8f399710a55f12f4da9b5d922bc28"
  end

  depends_on "go" => :build

  def install
    semver = build.head? ? "0.0.0-dev" : version
    ldflags = %W[
      -s -w
      -X px.dev/pixie/src/shared/goversion.buildSCMRevision=#{Utils.git_short_head}
      -X px.dev/pixie/src/shared/goversion.buildSCMStatus=Distribution
      -X px.dev/pixie/src/shared/goversion.buildSemver=#{semver}
      -X px.dev/pixie/src/shared/goversion.buildTimeStamp=#{time.to_i}
      -X px.dev/pixie/src/shared/goversion.buildNumber=#{revision + bottle&.rebuild.to_i + 1}
      -X px.dev/pixie/src/shared/goversion.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"px"), "./src/pixie_cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
