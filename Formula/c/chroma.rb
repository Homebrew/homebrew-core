class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "87a124198bc71814b326e7430d1ce50fb730f356d8db500978a94ac033f1009e"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0539c62450620338f363784d48d2204ede641162697a0bb48f9ac7a27726a0ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0539c62450620338f363784d48d2204ede641162697a0bb48f9ac7a27726a0ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0539c62450620338f363784d48d2204ede641162697a0bb48f9ac7a27726a0ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a3068377da0f9532cb8639d02f55e0ebb3ed23dce2d558ad44626eda22665eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32372513a7cdb1e7e2d168385dfbcd97e7eb1bae7776325a79dd35537e5ce95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27dd697a6825117ecbb09760547dba9fa5444e53e3a754b80f62a88a3645675d"
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
