class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "7fb73efd7378a784ce5cda960930ef8da01a9966e42ecc8904713a18b65e8f1a"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de4e0eb93742ab07d97b3308dd7676afcc3070ea113df704faa002ba81a3f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de4e0eb93742ab07d97b3308dd7676afcc3070ea113df704faa002ba81a3f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6de4e0eb93742ab07d97b3308dd7676afcc3070ea113df704faa002ba81a3f25"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c7696a089c73d1be94963aadb3ae97200395ec677c1464dbdbc164d88f1f1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbcc6832827b7d4d7640d8e4805ee5275255823de4201e62c92de0d4990fbd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2e168dec4701a26a11409a2e4a458666afa89b1d18559b6fa1c55a3bd76e82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
