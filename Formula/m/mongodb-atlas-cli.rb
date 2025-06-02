class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.43.0.tar.gz"
  sha256 "4ea9c80bd3956f92bfc0a0189b973050a77c187931e6b5adc8da91800fd4f204"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b101a4656b8188a04122e85a10d5979d756c60e76d64bb76a5b8397adf23eaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ed778f2475dd172e3bd442b341cc9337d48ad95df847beaf8b9c97322088e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11538a8177fa9e2980293eaeff7e6761abc6380e17ba688ddf2b851ca592c44a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5e015dd0fa9911d47c73bc46efab1062ce415decb9fdbbce543d7eaba2f0ec"
    sha256 cellar: :any_skip_relocation, ventura:       "cd62bc38ef94b36e5283ee7f148f16212889ce36010a9af165b7213a89f25d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220fc728a264f4d2648b16edf73065113d4cf512591a7ca188ebbe7cd8a15a6e"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  # purego build patch, upstream pr ref, https://github.com/mongodb/mongodb-atlas-cli/pull/3925
  patch do
    url "https://github.com/mongodb/mongodb-atlas-cli/commit/5537ad011ddc25b6cbe7fd7cab10bf20d0277316.patch?full_index=1"
    sha256 "8201cb67f844c7c52478e82590ac150a926f3d09bf5480949fb53e8db6a1d96c"
  end

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
