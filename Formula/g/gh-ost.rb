class GhOst < Formula
  desc "Triggerless online schema migration solution for MySQL"
  homepage "https://github.com/github/gh-ost"
  url "https://github.com/github/gh-ost/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "f1cf96257d3f29922a8bd5a906fd742d852cbfb43a0a607e778a9b135cf3133c"
  license "MIT"
  head "https://github.com/github/gh-ost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a496a3e0a9205f7b1ff3dcae5b3d93a9096a730f9ffa3e39582530c48755bc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a496a3e0a9205f7b1ff3dcae5b3d93a9096a730f9ffa3e39582530c48755bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a496a3e0a9205f7b1ff3dcae5b3d93a9096a730f9ffa3e39582530c48755bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c3e89a7c234ec18f84b04f022f7f7673929bf2299e7976d5619e5cc30f5866b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6637aec192abc4c548b758987fc5a720e0b1cbf41ed75658313be84c35aa281"
    sha256 cellar: :any,                 x86_64_linux:  "bbf75af2770920850687a6a224ac64c65aca8a44736050455f76e25e3ff5c814"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.AppVersion=#{version} -X main.GitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./go/cmd/gh-ost"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh-ost -version")

    error_output = shell_output("#{bin}/gh-ost --database invalid " \
                                "--table invalid --execute --alter 'ADD COLUMN c INT' 2>&1", 1)
    assert_match "connect: connection refused", error_output
  end
end
