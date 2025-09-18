class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.47.0.tar.gz"
  sha256 "f32667d98f118854e11ca718077adfcc501dc92ebe5d9adde9b94b8d75d1fb28"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b72d6c3f1fe62bc4418c987bab4b3828c604590d9eabae0214cf79e0c8ff7ee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3789c022bd69ec23cbc37d810de44243372295eca5a3f09408ca3256ab40fe2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255a83abe8d6d62b84bd9a81fcb50f1f319cc5eeae4c117c701a52bcbf06c639"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a32dbe39fc1c8fc00e0a0644a5ec85fdb04900d984aed80afbde9a1dad46516"
    sha256 cellar: :any_skip_relocation, sonoma:        "16b3f9606de82b6fb9f53974c7427efd931cb3d540e78f6244a7794b552a9254"
    sha256 cellar: :any_skip_relocation, ventura:       "c27889b86f9c217c7ecf47dabcf05f076858eee41498b3691fe7308946aeeeee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e019164f80f70adfcbb29ada1449124bbda7a64687b62c08b78e3f7c8245f5fd"
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
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
