class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "fed613f0457600a30713968c111bb1fc3b014a4ebb25acaaf45cdbd03f8337a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5e5204b640fefe62e35cb361a8434141cf17cfe1c075f6e1e90971150bd7387"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "795ffc08b586586cf5db980a881a541d9dd0f1f633138851cd792b373557df6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3810ff7324bc563a72f0e5759d4a686537b005af4e1429306493b398396ad08"
    sha256 cellar: :any_skip_relocation, sonoma:         "44050c71d0250428196bd7770896a7e5aa20d4be2d5f31adda6d8831cc68fe2e"
    sha256 cellar: :any_skip_relocation, ventura:        "e8f4d5f6288feae80457987e3c9e13e6c66d00874dd8df2641b2adfe42848413"
    sha256 cellar: :any_skip_relocation, monterey:       "ced6163225098afdae945e3af3412e46ad23aef6606221f60c277c10c689f0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a2e991dd05dfc47d22efa151f2495b667289b945b9026d04c277457188d910e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
