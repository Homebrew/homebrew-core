class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "cba8e70ed7e5b9da97dfbcf5929f8ee134a10115a64bb5d9167acfa0a62650d9"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c855dc8ab3dca34abeade8354513f4994a9f6fb07946d759d6808a81ce6619d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98cd0520f9dccac6bff3164493e50f8c54dafb1356c9b62f307306b6a13dd94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b735656501888e695b7a45e7c587e6ca796b932c3a6abac8864437915794201"
    sha256 cellar: :any_skip_relocation, sonoma:        "991f8c2522c30502b71370d2a9d0a74cf7c891cea24c3053940c6f814d606e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "375ad82138e22252bd01254223591fd35184878c7132a4f516b02127836b4103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85317e7f5fe08c0618f719c12957d62bb0077ae31282e36fb6bd51ca2645b23"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
