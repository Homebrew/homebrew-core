class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.56.0.tar.gz"
  sha256 "d96f57047fe8cbab345f3967f13c0619eb79fd14535ad19bf112c86f98bace05"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cedc9c82f96f110a57e694a17f82426339cf4695ec1c7cdae9c7881459e3bd0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5e1b0fdf7ac0c6c409f93dff763a0f321857e137c65e013783db245dcbb6a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f27404698a3e542c2c93c5cb95aa18c0221eb197a8f60120e8ce9994a1ac40"
    sha256 cellar: :any_skip_relocation, sonoma:        "921a2fae7517ea245e7a1672e483aedb0873d40637accc58065e08312ec8de76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda9c8e0d7f8b90e8fbd53674cd2811f1a5b37210bdd4aa2efa7b06dd85a3499"
    sha256 cellar: :any,                 x86_64_linux:  "fa641b5d9d34d92a11e0a853648cb455cb369fb5abd5767d3ddd1f8bd4054edb"
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
