class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8d98889affd190068022b4596a34b0a749a9f41f340b9b55cefd7591cf30bbbb"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a882882912fa852132c5a1f7c0597e81bfa735b73393738e9865abe1109b6a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597eab7d7d02d7dcae5e281627a8307988c0e9e9ca45bd227c2b33710d120672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ffc24b7a8d8ece002a343a00ce3509fadcd53a8e6ed74d1c9af62d573539a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efbfb4786a2b99a52a9dd24ee18bd6f97fedc69d98aef74790c8afd85941ba1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a119c54ad0ade50d449d113838e79db15d2c93b200bcc17459c413615aec541"
    sha256 cellar: :any_skip_relocation, ventura:       "6a508d2493c4537c729afc4f15e8a2b1b905d773d54486642920bc84da73c083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed64c0ab817d9b34ec3cd8243a5f4bf723246e48a90eea85fe23f8c76aa72d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b5b739d138121084051f098453e69d0fb54781235246eb1a693c0d95a9df6d"
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
