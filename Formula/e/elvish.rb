class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://elv.sh/"
  url "https://github.com/elves/elvish/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "3a4b93c3c99fe2f9847de35d64be24e2d4b9c12d429cd9831b4571993a66bb7a"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6965613c8e432735d93e6db58d0cfeab81638acb8ee0f2b81db3e75560687c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "84aa59f755bdb4654c0c2e10bb08008df2d72a7f3469f889c68eae28e0dbf227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5e08e6050cceab51df1c54230a03a0c9a55636c44533e18b606c1e07b9d8082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdc4fc34f7c55fe5808323f09a32ec4aac813ec2d467e40c001830f9ab1100ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4faa173bb273fd7fb4f3e2c11b597c5f0f2926b733df3f6e9eca1205dfcb1c84"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bebab1544e5e8a296212b246bb12302e5115dc1bcdb5d9722d7b08c5219e126"
    sha256 cellar: :any_skip_relocation, ventura:        "f14e578bcbe405c2e867d92e048da270f212ccd9335feee4ddf4f132d77b0a93"
    sha256 cellar: :any_skip_relocation, monterey:       "fd52f724fb5c36b8f393cbd610b6c54867382c202d0d2474bc832534e3303f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "73d28cc43ad48e808dd7d5fe0942a7d53da195e538fe8d76363f04915d6b0936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b4d25746ddb91b1c63be65408dd2e2c46b20e4703ebec8943e2697d9a7b990"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
