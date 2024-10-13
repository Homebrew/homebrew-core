class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7aec95af51d4d954ad01fcdd7e925269fa4cdbadab5484761c56fc54dc122c38"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b97337df265fafda2d9c799c804e889503ec51d81030d61f95a48a58d9958f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "903dda9a2dc16f7195b4bb3dfe94bcb7b91b1ec62b6cc1e89c7f9c3125b644d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "903dda9a2dc16f7195b4bb3dfe94bcb7b91b1ec62b6cc1e89c7f9c3125b644d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "903dda9a2dc16f7195b4bb3dfe94bcb7b91b1ec62b6cc1e89c7f9c3125b644d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "60c0887e8ddacd4b9cd8ba871acac5634b44ff46b7d1ce3e3e46ff1abca7a0d2"
    sha256 cellar: :any_skip_relocation, ventura:        "60c0887e8ddacd4b9cd8ba871acac5634b44ff46b7d1ce3e3e46ff1abca7a0d2"
    sha256 cellar: :any_skip_relocation, monterey:       "60c0887e8ddacd4b9cd8ba871acac5634b44ff46b7d1ce3e3e46ff1abca7a0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632e162a3f8827b9ef6518a554653588474fadfedd0dfb92cf3a5523ad1b3170"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}/logdy --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
