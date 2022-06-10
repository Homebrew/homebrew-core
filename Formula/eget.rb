class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0075a032e31e0525a8171b326ed8fb923e3d1e5e30201557d6820cf2ffd047ee"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548de2b28e6d215babe224db1504b37e9c3087b4b59af415127315891b6504b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc1ef91411d1e4705fd10672c4212e8cf7f465b74b074ccd856430edaa50b22d"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef7a49209b6424a7eb3721129e32dbf3a6352127028ed8ed58b4f0a4b153084"
    sha256 cellar: :any_skip_relocation, big_sur:        "22b9470d78fb564e71dd745d62de0da2883e53421e16d96c91df8d57cfbde07a"
    sha256 cellar: :any_skip_relocation, catalina:       "307bc4010946398399bba50019c8bfe0e97e32a8d36d1928a1c3c3eb41c35813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cc98e8941a3aab5f3ffa460017a74af2858ec922b4beae9b371e10454ae0d3"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
