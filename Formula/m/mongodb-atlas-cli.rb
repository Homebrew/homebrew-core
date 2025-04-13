class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.41.2.tar.gz"
  sha256 "2fde3af263e30a97f3f9c59f16a2356da8ae6e8eaf94c226b50abedf8aa92864"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4826fc6cab5e5deed5ea5230999cc97a91c9c20abdc8cbb17e9ce2f1e3370a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a8f20c466e7a5fc7968a04cac3f3564da30594ddfd35d45b3544ec9986c8162"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31542152af748f40b12abce712626386aa0805f24c0271306745eb968c99439c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe8649d80aec212a79bee29aa8104e2356b5219ebfa86bef08c4362e0ff5e3c"
    sha256 cellar: :any_skip_relocation, ventura:       "b0a70aaacc5eaf632b09b4d7ac87ffd081adf5af873050fdf8d2b448d2c908f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a85a0a27a63eb871c306dfc844922f91c4985c17532a3052b81f0387e94668"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
