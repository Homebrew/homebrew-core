class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.14.3.tar.gz"
  sha256 "c01905c338c4b9085b3cb50ef0741f69dfc47c65efe2f63aa5eef7b6e805186a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d544abbab1c0e71df8d24058f118c05f5b688bf5d5b5dbbfc543d0a857346b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e817bde1c13ac66b729729c1eabfbdbddd89176c772a200c9b5f7aea52a40747"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e17fec9e76bd3d9130bc449c3ca5bb2c51f95f023b29580510359ebdad653c4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "68ced8e5ee929ab0823790fb742e64442dc5f2366f65160688d333c2d921c428"
    sha256 cellar: :any_skip_relocation, ventura:        "c33f2223898dc98acbb5345cd2d8459b8d9726f18a54803899afba9c612b1c3c"
    sha256 cellar: :any_skip_relocation, monterey:       "5565796d6d4a8599cfc6cbde5e2989b37251998a93b4f708a1d605d0677953e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a12bff34b3bbf12a2db1d2165d7d15b2155b831d7ec15447685aebef8eb529"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
