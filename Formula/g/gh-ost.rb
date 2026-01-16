class GhOst < Formula
  desc "Triggerless online schema migration solution for MySQL"
  homepage "https://github.com/github/gh-ost"
  url "https://github.com/github/gh-ost/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "f3ebf966a84ddeb97e5dd0a70dd027c2d088c71dd18f72c1ac75373f2be430ab"
  license "MIT"
  head "https://github.com/github/gh-ost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d90c1d631ea76ba5bd0f0467a9f8a1800c6ad4fb236eb5d8629e3dfa6055d442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "169824cb9a89bebbe882099f1c7af4e7f79c43c7b97d616779af7414d7a4fe32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134fe24c116fbfb50514228339a9f3713dabef542c136648196e42a123e954ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5917eacf8bcaef37980ad7dc4b9258dc82ef3ff73911969aa692de7cb0875cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "f35b4b9a03a586347804e2f0f2a7ff0be06f7cd778a59f12a27fb9fa427dc310"
    sha256 cellar: :any_skip_relocation, ventura:       "837020c304c218e2f771e6ed99f5507e13120375696ffb306dd1d0d919528230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ac0b81e16244b2f3891e43bf601b57e9c587e22a3d6b1ae9ba8c95704d0b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41970bc38d03a5ff49d2a3d3ef93764e04af4cd9a522560ddd9fc42dd4889dbf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.AppVersion=#{version} -X main.GitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./go/cmd/gh-ost"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh-ost -version")

    error_output = shell_output("#{bin}/gh-ost --database invalid " \
                                "--table invalid --execute --alter 'ADD COLUMN c INT' 2>&1", 1)
    assert_match "connect: connection refused", error_output
  end
end
