class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"
  license "GPL-2.0-only"
  head "https://github.com/jgrahamc/httpdiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e3440a3284a54af6e5c28606e0d6ffcde2150980a740dd2a0bc27d435c04fba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e8f493a6c29a4edf788d888adc111c2f3727b0a725661f0b62c9934292f1c43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7fcb1b3bdfb03fa3238b6e837c99668fcdc340070519d1a8e2144171be14b33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e0883f20c870f02e78385ba604f33cca56c29e41037c1b42c98b9e231a1845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "290b6c6f1c990249cc760ee510f0669dd9e317ac169be71cd5fb945a8625413e"
    sha256 cellar: :any_skip_relocation, sonoma:         "541557da88ab0a9ec186d305cc0f65f8e25df8ad183ebbe80af829afbae87477"
    sha256 cellar: :any_skip_relocation, ventura:        "3dcf894a63441e77ae53928406016eb7b4c061588156aea9a6b5b28fb825b2a0"
    sha256 cellar: :any_skip_relocation, monterey:       "868da1b5aed20834315043ee38f653e34166b799fdf4ee90aa5967de099d8c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd0aa59b471dc747b3af50d5c1f4611ed2c4993eebe64ffb4d343d1d7bef0fbb"
    sha256 cellar: :any_skip_relocation, catalina:       "5731d30f22cf63bd619c18f0f91c4547c52f2ae1b38a2cfeb0316958e93995c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b75213c432ca3754d283de01029ae208a75955949c8b5b9e04613c9da943f8c"
  end

  # https://github.com/jgrahamc/httpdiff/issues/21
  deprecate! date: "2024-02-20", because: :unmaintained
  disable! date: "2025-02-24", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"httpdiff", "https://brew.sh/", "https://brew.sh/"
  end
end
