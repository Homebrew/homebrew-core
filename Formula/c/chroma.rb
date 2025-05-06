class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "731fc4ee95095156e8f84684eb7bb9543ce41bdb4a6459a0387b78ef223ed1e8"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4077b698556a4189b14bedbdd6db1c32c89dc9cbe527ac85144d4e7d3d6b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe4077b698556a4189b14bedbdd6db1c32c89dc9cbe527ac85144d4e7d3d6b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe4077b698556a4189b14bedbdd6db1c32c89dc9cbe527ac85144d4e7d3d6b99"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dce961501e8f3b80dabdd38d6d00a36cfa300cb5f318e3bd889b4ef9e04a85e"
    sha256 cellar: :any_skip_relocation, ventura:       "9dce961501e8f3b80dabdd38d6d00a36cfa300cb5f318e3bd889b4ef9e04a85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac754dad4d1cd43333a5cb0e243e58980d502ff2819a7a5c10f415b456760dae"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
