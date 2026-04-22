class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.54.0.tar.gz"
  sha256 "27b99d9b16fc5182f6e592742223ccedc92184e8f13ca6d9ec8d8338dd96839a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8225220bd03e20b96fdc41a9be3613edff4b4e3e6e60bafa64375063dfaf7ed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae18c7a00c095b231a4b908b2b3fcad9410bf8e85ced1adc5f36b712d2c6032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562ec14eb0dec1599ed32e58cf82f04be52cafa770dedbbfba9275848e576f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c8ab037abe96fc7dffdcd684dddc670f8286f7da3375e6fc6cd4610791e0df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd23c8adc057284d5d063254dc49610b02f1be76168b8aa9a40659d1a6ef7e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d8c9155ae81a66b521a58c2f2cd24c16d47acdba768797084552b067e48a0b6"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
