class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.5.0.tar.gz"
  sha256 "0c76543f68d7126a7980d723f16fac895893fbeffc6c7f414b4f3468f8a52673"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee1f6771be3c9d644c2a89cd682595f8ae2e9b0e01cdac2f03c6da8efd2b87f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0750696a0107f57210d56a69e4bad4175074da243f045f5fd522683e513d4ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5513ee2a086060802c500985c2c602862c6d726297605d75b69148e7aa0061a"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f69439bf309c3b4ca81565f6fa8e8ce3c79ce0ba4955b5932c75d034a1600b"
    sha256 cellar: :any_skip_relocation, monterey:       "f837d06ca75f12f94b6ac3714151d249063eb21a62ddc4330c4cb45d726db70d"
    sha256 cellar: :any_skip_relocation, big_sur:        "560c0a85e6495726388b70df0239cf0096973b78f0eedde295a778c5e925e763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4460611ede37f0d518450b4f6fa132f4e95c51b396c3325de9ca70a0bf13b5f"
  end

  depends_on "go" => :build
  depends_on "mongosh"

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
