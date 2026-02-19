class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.52.1.tar.gz"
  sha256 "a1646544085ecf754650ea0d8224c869dcca3864b6f4768b85feaa437b81ea52"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc7756a44e410f7b10d1b17fd7e9b359254c951e62c939237bdbd0d8bbb8b87f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362b9574f8249d812d6c02ff274003307f86cfbcdbee3564c38dbc59e5ab2876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae8deeb590ac145f163971d6e54b6c01f25af8a8211de068a5dc4cf0c131f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9009db08629cda7a210b9d1e3d87833c039f6c7675fa536c9ebbc58b3e898757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "802147854b72f6a1d531498f5e6e20f028332cfa35170e55873e76d74c8ac286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "865afc72a0b807f76fd585b47d8e3335887d834e08437742905b18bdbc35d6d2"
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
