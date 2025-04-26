class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.42.2.tar.gz"
  sha256 "8b7565024b6e73ed00c8b451cd76aefa3944951198d676305879e80a223e54d1"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6f860f3e1e6d90af9d5f35024550ee10fd65844af8b904c4d200f29192b4b2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33af21e7bed48ca70be29bb1c7cf4ac9434b5deec8745dc6edc887d51fd4b006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "624a8ffab4868f37250845b90994e2c8a17de2e7de59c75f5b28f6591739f686"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71eef399664a2501cb57d8b053898df3bedfe8208b081a557746e21f35b7a96"
    sha256 cellar: :any_skip_relocation, ventura:       "52d0ebdff7f86bf340726edc66dac8f087d52bed119ac3e4386f9bc7ad3a1c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953bd43cedfab77e8ebad820247a7bc59a85faa6328dbbf99fc5a6dff1fb6ec7"
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
