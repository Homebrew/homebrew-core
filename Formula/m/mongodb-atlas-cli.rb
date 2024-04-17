class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.20.0.tar.gz"
  sha256 "49fe640b63085a4883efcff5f2ecb897afa36d1d6a1c1c75d14f773b08c0f602"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c85945d2c7d117665711e099ea1baa28f81e7a4f41dc407311dd638e964cac37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "283fa2f8580e88ef1d1cefb3b77b79a09607688a07e0347f3fd3a802fbec3809"
    sha256 cellar: :any_skip_relocation, sonoma:        "7102ee1b1af8afb56a06c4b5168ead66b552d6e96a3fa346c1e150e5b9988baf"
    sha256 cellar: :any_skip_relocation, ventura:       "85f39f013e53a703d1c0448370a43f918e16647daeb2cda3840e85d498d39718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9256dec36b354a076334c3fe819941adf9a7c9a0a9c8c3f9adc08beaf0224f"
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
