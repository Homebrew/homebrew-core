class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "d0c337e508ecfe6014043ef54502f6cce86b1e20ab58b9f89be84d8a4940eb16"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ced6ddc02be488d8e9388493bb83b5de22104ed76be92feb93b9581337c358d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66ce0a31c51651de8192ce50784291c4319fce96422a3e280c4e9d9ddf8814bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e76d14432a9cd90dc6bebf83ccd03ff42b9b298959b4b55e4cd8d46736bdfb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "812fa0213e890148e6b4a67cc832ffd8f279d1e1e48c07f16370a1df0cc609e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8310e0b869d96bdb42177cc4e1daacde35992ce7ef9ec3a6ce1db4bc9ff6c9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a13ed53d3dc93a7f5581e34c4207c07e6229c41655b06fbb77b2658e0f4ad55"
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
