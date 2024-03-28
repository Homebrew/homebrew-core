class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20240311.tar.gz"
  sha256 "5d46ab41595bcade23928a0aa9cff16972ee46e0a904a2a28c318324ccb669ce"
  # https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Standard_ML_of_New_Jersey_Variant
  license "MIT"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d59a4fa943ba0fc40fcf7b83215b728f1566faca0440c203a604c4ba605d9b7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8135309c68739e22a9978bc396f1d48a6f0e5dd5058d99a0610d6981239575ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f1269b3fecf4541b79b33e78aa2717454c19afe96c8e58a3e3bdf2f34568c71"
    sha256 cellar: :any_skip_relocation, sonoma:         "efc004e18bd03606edea04a13a64d4f73d18bc0ba35187aeb8c8b26c6c3258a7"
    sha256 cellar: :any_skip_relocation, ventura:        "0d551904ed75cf5d59500cfae560558cb73778d82c46c4409d3e32a34b8558a9"
    sha256 cellar: :any_skip_relocation, monterey:       "61fe03cfdd3c21c30b50dbeaefbdf4b0b96546268bf0480dfb0ef40b3e917f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72cd6ae9d87e6fa7275cad4fd3fb61f66b05cb63360d707fa01c8854fa0abe78"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
