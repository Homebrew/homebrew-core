class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "5d74141cad6c8fa3fec86c5b63e4722bc0e8e3708bd8a900dc7c55197a7f08e9"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfa8e121d1e3e82b3639d3739aea6418d03cd1fa0f467b0c54f74eb390f1e4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfa8e121d1e3e82b3639d3739aea6418d03cd1fa0f467b0c54f74eb390f1e4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfa8e121d1e3e82b3639d3739aea6418d03cd1fa0f467b0c54f74eb390f1e4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1acbddc01901454bbb651f7161667774628fcabf864de0886062417c087d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d63508de037579a6c9d968842c28bd16da93f712ddfb380b838fb5c1d0488e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d545f7df8f10dbce008d20b8679921f1cadd042a4ca1e369a1c6ca9fa65ea6a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
