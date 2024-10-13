class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "fc657cc752c6818f6658ce46cb3931004f55b7bb536de25be56f80a756ecd911"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f569e3b67095bfcaef12ad472152f4c0f37ce5179c103b8d61ad5e0b91025575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f569e3b67095bfcaef12ad472152f4c0f37ce5179c103b8d61ad5e0b91025575"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f569e3b67095bfcaef12ad472152f4c0f37ce5179c103b8d61ad5e0b91025575"
    sha256 cellar: :any_skip_relocation, sonoma:        "95236bc14906d4459ccc5384feaaf5eb13bc65ab505dd43b7dfe2124d22ffbdc"
    sha256 cellar: :any_skip_relocation, ventura:       "95236bc14906d4459ccc5384feaaf5eb13bc65ab505dd43b7dfe2124d22ffbdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d4a976ba7fcee08561b378a671bc31f5cbc089e7f058d838c85fe8efe25b67f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
