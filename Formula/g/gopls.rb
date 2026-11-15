class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.24.0.tar.gz"
  sha256 "5ecc22f581cafe4039873e2f28e0d045efecfb0dfc6ea51ee1345daa694cb6a9"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ed5cfdb5abc77788ba91e6018d9e301e3327100cc6d305c2f60106596082956"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ed5cfdb5abc77788ba91e6018d9e301e3327100cc6d305c2f60106596082956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ed5cfdb5abc77788ba91e6018d9e301e3327100cc6d305c2f60106596082956"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b545ef49ab6628823fbf04915e3e968d49e25a19265d0fd477024b42e945892"
    sha256 cellar: :any,                 x86_64_linux:      "c44a6ed56a2d34391cd262b6b27596fbe20b1e59ec02d2e02f3f5c99afc6639a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "gopls"
  end

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")
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
