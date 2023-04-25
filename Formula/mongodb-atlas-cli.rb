class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.6.0.tar.gz"
  sha256 "736591909f205c52e2f8dceb8918fb6a0a9645ef387ea8ad2dac3a81734897fa"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0942b26f5e31fa1e1f394fcad6b5d27c7e646459f9c7c31e1fc3e15e1dac83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c559251da4f33523e96d76285ca87050cd0f1b17696f6bbe66bf7c9cf10690d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cae5fa2ca613a5490b70b1c1780318076a9eb57493db02d76a53de179cb42a7"
    sha256 cellar: :any_skip_relocation, ventura:        "9b08a67959285d19a167c6989320a9c92937a3c2f9fc56da6ef34c840e2abf39"
    sha256 cellar: :any_skip_relocation, monterey:       "8dee56a6fb1143f1ef6e6173362371ce078f916718619c696c9ca8f6290f8a02"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a80bcb1b750142e87335fcea1f0d627cc94de2d65c6e5be27a4b579b46769a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b97e07660a93d53dc853708e16a5e3c516485495007214ab6f6c255e965dd9c7"
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
