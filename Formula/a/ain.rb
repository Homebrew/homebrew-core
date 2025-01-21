class Ain < Formula
  desc "HTTP API client for the terminal"
  homepage "https://github.com/jonaslu/ain"
  url "https://github.com/jonaslu/ain/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f886d5df83abd6788ac4f1875844f51d609fa1f466b8af5a5cc8acab92781cc5"
  license "MIT"
  head "https://github.com/jonaslu/ain.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "661cc461e836d8df796083906bfa40af3689af26ee9dfcf52abefc6f5bc7f164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ed631c64904849f645f34d812545b8c33fe8ab92b01b8225a295c4ebe6e4012"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed631c64904849f645f34d812545b8c33fe8ab92b01b8225a295c4ebe6e4012"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed631c64904849f645f34d812545b8c33fe8ab92b01b8225a295c4ebe6e4012"
    sha256 cellar: :any_skip_relocation, sonoma:         "12231aa6ee4849a06f073e2030da41626d9f28de97b12ce206755b841ee256ef"
    sha256 cellar: :any_skip_relocation, ventura:        "12231aa6ee4849a06f073e2030da41626d9f28de97b12ce206755b841ee256ef"
    sha256 cellar: :any_skip_relocation, monterey:       "12231aa6ee4849a06f073e2030da41626d9f28de97b12ce206755b841ee256ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24edf0665a2356575689840d7a04971f351d28dd074e3f9ca5b5692f7125ffa2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitSha=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ain"
  end

  test do
    assert_match "http://localhost:${PORT}", shell_output("#{bin}/ain -b")
    assert_match version.to_s, shell_output("#{bin}/ain -v")
  end
end
