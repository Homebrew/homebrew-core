class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.58.1.tar.gz"
  sha256 "ea5279bca8e33ad9032d9293a8f58da3628ce68e29ddb728e8b3144419326287"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b931b823113daf06398d6c42f946814a039a9ca0618c504d947ee259e9cf7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7293e2528ce108c46323d12e5d93338518bea56c961c3e3b71c4a469e9ba4b22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f35b4603cc8c295d6c6bc952ca89a734a673c6cf6c1a4aa77cafbc3890762373"
    sha256 cellar: :any_skip_relocation, sonoma:        "1736bba0490c338d4f3db9f71d2e385bf711ab3a8ee44d8885c4259eb10c2059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccde930cb9326e51f71c65da86d876fa323dfbfc1d481fc88386316722acb29b"
    sha256 cellar: :any,                 x86_64_linux:  "1fc7735313edb2afa04b8f570e4a0b30e93f6f76b8f098ffdbb0db7f5c283b7a"
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
