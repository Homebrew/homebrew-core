class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "7fa3039bfa6c06a688c1094177445f759c592be2f04574a234da7a88ab2d0efd"
  license "MIT"
  head "https://github.com/fullstorydev/grpcui.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96371f211cdbdcd5d568f474d105235f0b3ebdb624b46af9d29691a7769f9c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac35799e9b7d1c2a6c9eb8b1672f10ba975d0e32efe2665de2ecdc55d10ceeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ac35799e9b7d1c2a6c9eb8b1672f10ba975d0e32efe2665de2ecdc55d10ceeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ac35799e9b7d1c2a6c9eb8b1672f10ba975d0e32efe2665de2ecdc55d10ceeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7e1920f634f492ee2b36de11763a0dc3b3f16e6c4691ef66bf5d1a6c651a30"
    sha256 cellar: :any_skip_relocation, ventura:       "ba7e1920f634f492ee2b36de11763a0dc3b3f16e6c4691ef66bf5d1a6c651a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678cb499d5e1ff8120437eb008be019761b5afc74175df5ac292262a09dec25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a604659d4ba4f40852cc1d2b7924e0540f3e59f9f5628472826dfc6b0022dde"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
