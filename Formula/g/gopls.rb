class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.21.0.tar.gz"
  sha256 "c223293463c98039a930cb604d6ff04caff5cd6a3d45e7394cda1f11d8cfc0b5"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cbe7543d891f87887f8ed82bd76b8a8ac6be7afb79958a161170a7c32e6a3d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cbe7543d891f87887f8ed82bd76b8a8ac6be7afb79958a161170a7c32e6a3d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cbe7543d891f87887f8ed82bd76b8a8ac6be7afb79958a161170a7c32e6a3d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5697df85dba7f696de22725a3c913426f4055d2fb9037946542c5c27a294ba22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e3185885a9abeba14af86fd40c2381e674f572d71acb644f4dd5c31087fbcac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2964c09062699988c3f00ddfa767cb934de8a7f41d627d598d19e9d74ff872e"
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
