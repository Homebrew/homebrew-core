class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.22.0.tar.gz"
  sha256 "249dc0c4b9f3e853f6a7fb6f3528db2f48793e7c54323f3b32aa38f6432f088a"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1afc09f427354f41246b19670e4891edefb65d2792779b49e00eced268f3a072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1afc09f427354f41246b19670e4891edefb65d2792779b49e00eced268f3a072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1afc09f427354f41246b19670e4891edefb65d2792779b49e00eced268f3a072"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e0974d38ba09332484e5017b2f3e3a09a52fc018b9c5533a41e51d97e02101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a71640700c5b57ea8719da6b35e1ace1a6aa4e4e0b29b13c96523c003512382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1677efa2bec78b70788d99c0443c16c418bbebda4a0cccf6963acd1c074864a"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}/gopls version")
  end
end
