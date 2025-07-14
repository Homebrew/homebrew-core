class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.19.1.tar.gz"
  sha256 "11fc066d0ad6627668ab4dc4d4a34e6e0b47de51bfcc86c3f58018a020e7a071"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ba39dd845e7ecac74894978488ba155376325949c29013466b815f196b223a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ba39dd845e7ecac74894978488ba155376325949c29013466b815f196b223a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4ba39dd845e7ecac74894978488ba155376325949c29013466b815f196b223a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae91dc1bd5c8cef79923913089ed6fa35f4d304794b8c5b9013078f394d054ee"
    sha256 cellar: :any_skip_relocation, ventura:       "ae91dc1bd5c8cef79923913089ed6fa35f4d304794b8c5b9013078f394d054ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89bd5fa04588d18cc207677e58e17251127289daf7362efa64245c41a3d34063"
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
