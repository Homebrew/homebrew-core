class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ab3181b8603c32606839d67721e5eadcf4942483fd80c8d9072f8352a1241df7"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b60cd9a5fb26ce865266b4aea9e8444ac7530e960b43b3942868205e5a4c8e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60cd9a5fb26ce865266b4aea9e8444ac7530e960b43b3942868205e5a4c8e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60cd9a5fb26ce865266b4aea9e8444ac7530e960b43b3942868205e5a4c8e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f038d4fd182ead2a842ca543c74fb00810d66b2df1394cda3ed11c7227dd28e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b8c9680aab6bb810cb0c48ea9b37cb7e816c0a495705254dc53b7975c606aa6"
    sha256 cellar: :any,                 x86_64_linux:  "9e549d513e1f4dc3dc567c68f122f661c450fea29b1bb4e09d179c1de532c103"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/mcpsnoop"
    generate_completions_from_executable(bin/"mcpsnoop", "completion")
  end

  test do
    ENV["MCPSNOOP_HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")

    # Wrap a trivial "server" so the shim writes a real session, then check it.
    system bin/"mcpsnoop", "--label", "brewtest", "--", "true"
    assert_match "brewtest", shell_output("#{bin}/mcpsnoop export -T text")
  end
end
