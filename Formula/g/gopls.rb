class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.21.1.tar.gz"
  sha256 "af211e00c3ffe44fdf2dd3efd557e580791e09f8dbb4284c917bd120bc3c8f9c"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1991fd339294634d7b6576de9f101e71b5fe1ab78cf0de2ef38fc56be60e1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1991fd339294634d7b6576de9f101e71b5fe1ab78cf0de2ef38fc56be60e1f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1991fd339294634d7b6576de9f101e71b5fe1ab78cf0de2ef38fc56be60e1f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "63c6dfdd1cc1c2927888bac68f8bb6bb40e283530ef065046206e303888941f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc320a44e5a73f55f31c9f78b93ea4e11925b19aefb1b3f9f1979325174f8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3ca52daa50fd77434b69220279c28ad44d6c4b0f627c612cf09e38246d9d59"
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
