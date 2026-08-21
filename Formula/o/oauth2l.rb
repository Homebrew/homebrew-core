class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "d7e2c5ba8af23f465dc318b12886665fede1ff06e6980636cc93eab70e267144"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08a93e75b1713bf15e5d15d65e8cbfbc963937ddd1976ed30c58d182a41ac088"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a93e75b1713bf15e5d15d65e8cbfbc963937ddd1976ed30c58d182a41ac088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a93e75b1713bf15e5d15d65e8cbfbc963937ddd1976ed30c58d182a41ac088"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b25b3413746e6c589445aab327bd2f290f2a000fee365c2b9ab378c8c724b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a52db67d26cc00ed40f0e958412aabd5cc77553b37309af67cab03dbaa09bdb"
    sha256 cellar: :any,                 x86_64_linux:  "c5af25bea788fa75e06325500cef1c3a9c2b5cd92f02914a0b8eb672da55ed6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Invalid Value", shell_output("#{bin}/oauth2l info abcd1234")
  end
end
