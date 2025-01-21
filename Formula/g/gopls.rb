class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.17.1.tar.gz"
  sha256 "5794ebd3302ef4fd08de284834b22810dbb17b7e08efeeaa9b96d5c94eb90d6d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b7a21e9a9e1f0bdf85553420eb00edef566965533135dde983cf1caf7edc3d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b7a21e9a9e1f0bdf85553420eb00edef566965533135dde983cf1caf7edc3d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b7a21e9a9e1f0bdf85553420eb00edef566965533135dde983cf1caf7edc3d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "14cd9b99d641f03db5e89e6427aa53f73f6069b21a76cb634e86931811ef160e"
    sha256 cellar: :any_skip_relocation, ventura:       "14cd9b99d641f03db5e89e6427aa53f73f6069b21a76cb634e86931811ef160e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9fbb20446b2b78e7d0fa7b90a267d180bf028bd8296a6b78f4df87a06b6eb2"
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
