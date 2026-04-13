class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "153a26a64f09a7c3d60858b29ba74e191e3bf6ce433965cf72ab140691234826"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c480a675f0cac9c07781b2876042865839c36d340a173a7e55b9e22109beb3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f07768fb64c92c2c04eae4982021dcd91f8217b8c08d923abe5739497c69c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33df7af335dc21ab2306cd24f1c294d513dec714e833f62b40be27834fa1ac63"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae9309dffdbe26259eaec181eb1a904d195db834c01e10a63e8df45b1969b815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0e88668db3e8703bbd7574c530ff9ad053e8624818270a7f46c0b93d2030609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6b4dc162983f3a0076eb1e83c1204e99561c837e46e5555c67cbbd223be1e2"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
