class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.6.tar.gz"
  sha256 "5b060df9200c7b267fb88b3e5413fae2f2755078561fb983bdbc91fcca0f22e2"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ea360c2b9d10fe9fb869d5e4aa242e425982cb455cba92dfbd3d4454d36edb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28ea360c2b9d10fe9fb869d5e4aa242e425982cb455cba92dfbd3d4454d36edb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28ea360c2b9d10fe9fb869d5e4aa242e425982cb455cba92dfbd3d4454d36edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9e12994c34e8da8d1dc292048d05410bfe63c9ed9a1740acff31362d48d9dc"
    sha256 cellar: :any_skip_relocation, ventura:       "7d9e12994c34e8da8d1dc292048d05410bfe63c9ed9a1740acff31362d48d9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5940418a8305b16349ccc904da132ff7be73c40b838861e1942ff6da479a29ff"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "No valid login session found, triggering login flow", output
  end
end
