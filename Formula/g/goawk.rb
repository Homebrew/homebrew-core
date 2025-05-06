class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "9c355857faf7168f99e78d090ebe993ff10732a5ff34735cdc3e86256ce8c989"
  license "MIT"
  head "https://github.com/benhoyt/goawk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd5339a8bba3c9ee983d6891b6183f7a6fa98e5d73072182e7448706ea0de4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd5339a8bba3c9ee983d6891b6183f7a6fa98e5d73072182e7448706ea0de4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffd5339a8bba3c9ee983d6891b6183f7a6fa98e5d73072182e7448706ea0de4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "32408893fa7255daddaf5278f5a1c777f9ff70f5ad153a4b5b186a884be596db"
    sha256 cellar: :any_skip_relocation, ventura:       "32408893fa7255daddaf5278f5a1c777f9ff70f5ad153a4b5b186a884be596db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "151a9038108a04db71a18e51063a92b418cc9e4c1565d7e2074bb024414a86b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4d6651ac02692c4dbe0dc9727cf40e2d594f94e9ed4e52dcb1be65a6109cfc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
