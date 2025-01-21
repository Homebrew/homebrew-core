class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.35.0.tar.gz"
  sha256 "d77f3cc342f764e10a5310482340a98b5f068501f23761f92f4bf8e6f0eaaa88"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f180c5708db37265e87bf923672177b62ef7cd6ace4b8697331a4d0d2865e779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e7f4ac59f9753470644d9ed5c528ba5850e0c9453dd1691cc6dcc06b0223d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f890fd74cce0d0a05102574b68a719fd9511e7cdaf32b6ecf96a5ad54ec9d7bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6437cf99ad28778da82d730a2d2d373c11d68d7325abc09c606160bbb1bf9c82"
    sha256 cellar: :any_skip_relocation, ventura:       "b2e71f3e9e33a1fb08ac961947927ffa95e26fce82ad0f6d3e50358ca55d6e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3a9136f5e7ea15323b8001ce7dff59c2c6486ffc5692f71ab17270161dd40c"
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
