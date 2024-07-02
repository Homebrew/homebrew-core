class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "fe126647562da6d7224f39c2bc9ac2a9312e991abd70cf8cc245c8489034a5e7"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e69fd78521b500ab8ceb0d687bfa9881bc8283b82c1f26ae639421a8546a9668"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02d67d1563e2abc882a56289baf5008e6033317f7883d448c7e14378c071c57b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a6f01d5c8678a87f03a80867852f8206f83b468f0d3d383c6f0b93ec01ed92"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecd3aa68bd8c6b683011356e532147ad5d06539e4efbd669df0744d01559cc9a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d69e8f9954d948b410a29791ff7d4b842dded9d2b7a3638c0a10e6ecddeaa3b"
    sha256 cellar: :any_skip_relocation, monterey:       "9e185277eca2dd4e4d9691738ccede9352207358cc365ae2d089186f4a7617ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e04a513a72bc849c7f03f1cef33f12776b9176b4855d044c55d5c79a91c8cda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/awsdac"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    EOS
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}/awsdac test.yaml").strip
  end
end
