class Pangene < Formula
  desc "Construct pangenome gene graphs"
  homepage "https://github.com/lh3/pangene"
  url "https://github.com/lh3/pangene/archive/refs/tags/v1.1.tar.gz"
  sha256 "9fbb6faa4d53b1e163a186375ca01bbac4395aa4c88d1ca00d155e751fb89cf8"
  license "MIT"
  head "https://github.com/lh3/pangene.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e9554d2a1b331e934b0406114f7715310f2ed7098974c296aeadb30a0c9bcfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd8173d3cdc049cae0b8d4a5552e37a3d8e0d1e005c7b0612265f21ce95d6000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05bf28efff30aec8113844714eeff1304247a691021a60490cf75b6c54705a79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e905200f81de11386382c91f4e9dfea33dd602db225fa38176334fc270544649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5cb10124741f78bd51cf03b6f95c05c4b49d014ddfe1176a2ae8f39a2fcd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760dad96c7446a19bd22cc485545e821b9a0f671c0b57803a4e15f2eedf36e5a"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    bin.install "pangene"
    man1.install "pangene.1"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pangene --version")
    cp_r pkgshare/"test/C4/.", testpath
    output = shell_output("#{bin}/pangene 31_chimpanzee.paf.gz")
    assert_match "chimpanzee", output
  end
end
