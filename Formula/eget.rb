class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "81804a0663d2ba79a034bc62422ca242fcef6dea793a8bc8293d0f596affae07"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b7b7a259d17a6e70cbe6519d4f812be14ff0efe089ad331b5f90aba5d2887a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1b5f987db5a518797d970ec2609ab07c4e5f1d1a2cb38adcdbfd68e9be3499"
    sha256 cellar: :any_skip_relocation, monterey:       "184847b57c01b6a76d801105a98519e01c5593953c6d82c36b6b9fef6a79ce31"
    sha256 cellar: :any_skip_relocation, big_sur:        "519ecc53dc11dbb9f2e374103037e7a9fad411a2ccbe1e271da72b4bf5f586ee"
    sha256 cellar: :any_skip_relocation, catalina:       "002e01a58f8acbba30d334e3fcea7492d47147a2a038a1669b8e3908ee19b69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4134a552aef0ea9969b992d375acfb36dd459d70e422ed860256bbd98ff4cb08"
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
