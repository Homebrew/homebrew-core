class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "1ee811f5c32ed6cb47e67deb58c0039b13560f0d12cb47fdb6f193d8cf4cbb1d"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1d4349aa7133f4c76fabc875c2c3c2ca6129daed98861836e081a8eef6197eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d4349aa7133f4c76fabc875c2c3c2ca6129daed98861836e081a8eef6197eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1d4349aa7133f4c76fabc875c2c3c2ca6129daed98861836e081a8eef6197eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3529ad775bbe50f3233e31d2215823da535b058e8b4cba5541d191a36c8da0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f034ff170f173a03651a414fb5276c5b7912a3784b0174eea6fa0335142008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acb003a428ead725a9640a577e6c25321a05c07111789e3fac939c411b47d07"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
