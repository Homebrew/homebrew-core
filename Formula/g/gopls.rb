class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.15.2.tar.gz"
  sha256 "cf5b8246b36967eb8fbbed518ea941110cc6bbcc7f42a44bc5a4fe0d7ee61652"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "802a5166633e85df586e99095025f32907340e34ddb9bd8a5b992a4dcf2c4781"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fec89a63bca5d661b0e0112ccdf6c8139c68c5366fd77c685189a526f72faa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ecfa256180be9217979455ef43bb80bd575cc7efc7b11edab5b26d5f61b7b9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab4cc6295cf0222343f7e77412f267f02217eabfbee2ab73b10cff683a700845"
    sha256 cellar: :any_skip_relocation, ventura:        "5ed5947d8ffeaa1a90e0bbab480026e7c41037acd9827d4a3025805e1ba8c069"
    sha256 cellar: :any_skip_relocation, monterey:       "46b8ba855e8be80bb585c7f3bcc397e87498c9e76bb5e31d943dddb0f825df3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89f024341adce510442c99a5949f132f771908923adf82f232c6a368136c8c15"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
