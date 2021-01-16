class Fields < Formula
  desc "Command fields extracts columns of text (replace awk/cut)"
  homepage "https://sethops1.net/post/extract-columns-with-fields/"
  url "https://github.com/shoenig/fields/archive/v0.1.4.tar.gz"
  sha256 "ae9bc0aad79b79edc3b079539ecd804e04816d61af26e6b15aba35c51900f1b9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "31e0f9333be8b04117726fee9405a909dd8b32b6331d3b34e6a334ba7760e65b" => :arm64_big_sur
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "false"
    ENV["GO_LDFLAGS"] = "-s -w"
    system "go", "build", "./cmd/fields"
    bin.install "./fields"
  end

  test do
    assert_match "2 4", shell_output("#{bin}/fields 2,-2 <<< '1 2 3 4 5'")
  end
end
