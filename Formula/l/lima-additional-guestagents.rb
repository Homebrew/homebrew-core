class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "51e0461c719c67c87310a1df4c55afe83f8379c246cd66c1c38773785f7994c8"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11a4160b471c73ace6432962f14cb98b5c0d9700ad28ab730e90dfcee59d566d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bf19348439dc6c63e6f7d30efde868bc5e6cdb454c2e78e89529d24bfc2c668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02468446315cadbb719f105cee2c2ca9500ff04f8796620c47e0448d72e77a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "acbf8b53890d481b25a1fb2a73026f43b42cc640cc72c7ef0b06e6384427f080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d19852789cae469ea8899354ba365abb73bc33fd8a328a9cf58b0213319e788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5472f3ae4ad4abb52f3b929c67146f574aa05f64e49cc92fc54c353a44cfa09"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on "qemu"

  def install
    if build.head?
      system "make", "additional-guestagents"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "additional-guestagents", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]
  end

  test do
    info = JSON.parse shell_output("limactl info")
    assert_includes info["guestAgents"], "riscv64"
  end
end
