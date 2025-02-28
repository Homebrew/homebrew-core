class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "8548a3ccde0b886ae14ea78fae3e58d28922079e78a08d29e6ef7b9230190375"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d539469158ca6d9251f59f73f8e28fde16cb9ac1aa4b020779dff541a598c4e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d539469158ca6d9251f59f73f8e28fde16cb9ac1aa4b020779dff541a598c4e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d539469158ca6d9251f59f73f8e28fde16cb9ac1aa4b020779dff541a598c4e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fba7a344784edf9b66f342b3ff5d25b06382575af0a88dbc7feb72ebe28010"
    sha256 cellar: :any_skip_relocation, ventura:       "81fba7a344784edf9b66f342b3ff5d25b06382575af0a88dbc7feb72ebe28010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f9ea45b95ffbb8d29ca4104421829b02ed3079f570d745620e77ac9afcde98"
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
