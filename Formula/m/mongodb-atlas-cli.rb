class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.23.0.tar.gz"
  sha256 "2d970d2b519270402e019af110f50bf5eeaee5bd976471ac2ff74b814dfc75f7"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a301e558bbeccda37040e9ba6db161111467a3f5909293bab06ee032fc2760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aa9adba1c8726f6fe625904279b8e9194c3d60c4995d8f69531f00b1925dc17"
    sha256 cellar: :any_skip_relocation, sonoma:        "70a1f74a746e794d03deaadd8a969f2a8c93dab8901617b665fa6bcbb447ebe2"
    sha256 cellar: :any_skip_relocation, ventura:       "a0d3f3922cb3474fdf8c982edb16bcd42b78e592f5302d27dbd200a46a02c699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b664321f30ac4db8815bb7518c863b5b7cd39e500dd3af909f0872b97c5ac9"
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
