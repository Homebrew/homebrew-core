class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "fa65d1f42719b23309259af4c5b02b1ae435771ea7ecb39c44ba27974d1431c6"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45cc8bc25c0e58336d003756bb56fd64e7fd0ccd4632092c669f7c9dd84d425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcc88380fdbe56754e03780462af0b6bed267bc208a6605464eeafaf25f1e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2e43bb0117c0506fc5380ade27f49e0291c4d3321ebef4c180fd3ad267fa4c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dafb99f1425261d43809009f66dc86eb5496d12255358f22ab62e131845e5877"
    sha256 cellar: :any_skip_relocation, ventura:       "afe85eae1aa3f78180566e9d0764b3d3d362af421754494cc023015ebf894336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d16ba48aea3c81bd73432a4f3732b66b1cd63f6df6c6d7c56a23fbc0610e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ab869540b7d63439b0bc438f3309b90eeaf9f80915089e5ba072083afa0301"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
