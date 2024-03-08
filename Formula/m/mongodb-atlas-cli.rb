class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.16.0.tar.gz"
  sha256 "a36a48db85e545f0ad579cfaa47489f1d5b7f7eadd4e165bf0a1a4ca3a80362c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b69011d408a64dcd4f379d059c825af5c03739ffd97e91d3c0449fdbc222a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "444e47dffbe477082b033132df2f8e25c48b54436d39e2190905f967546acb90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca484553448ed757c8c2c80703ea68c4b91c2c1ea4ce3d4bfdad85b25db54cf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e6772b1ec463b32fdcc2473c13ad50959d338bde8b859ed31681f7ce2951421"
    sha256 cellar: :any_skip_relocation, ventura:        "4c5d245e1cb463777fd41b382bc0005ae36d1c1f1ec4b44423466412cce89621"
    sha256 cellar: :any_skip_relocation, monterey:       "ff48dc3436287c85f4c1af8f7dbae44afad653118b8d71a50c3834d4f22c1f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c2c16a241dab68e43ac0d54c50a73ca594911e4bd703724c91a5fa95f59ea4"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  conflicts_with "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
