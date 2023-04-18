class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"
  license "GPL-2.0"
  head "https://github.com/jgrahamc/httpdiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7fcb1b3bdfb03fa3238b6e837c99668fcdc340070519d1a8e2144171be14b33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e0883f20c870f02e78385ba604f33cca56c29e41037c1b42c98b9e231a1845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "290b6c6f1c990249cc760ee510f0669dd9e317ac169be71cd5fb945a8625413e"
    sha256 cellar: :any_skip_relocation, ventura:        "3dcf894a63441e77ae53928406016eb7b4c061588156aea9a6b5b28fb825b2a0"
    sha256 cellar: :any_skip_relocation, monterey:       "868da1b5aed20834315043ee38f653e34166b799fdf4ee90aa5967de099d8c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd0aa59b471dc747b3af50d5c1f4611ed2c4993eebe64ffb4d343d1d7bef0fbb"
    sha256 cellar: :any_skip_relocation, catalina:       "5731d30f22cf63bd619c18f0f91c4547c52f2ae1b38a2cfeb0316958e93995c1"
    sha256 cellar: :any_skip_relocation, mojave:         "6113414a69c11632f0088e478d6db0acc6b826db7937c3570e661152c58bd334"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1432608ef9e3ffaac9fc3c6207e63d888dd2246e1c806bc6a57cab312f944aea"
    sha256 cellar: :any_skip_relocation, sierra:         "39a0d685904aba4c3e55ff22b4d231b8890c022a1eb0366dc264bbabc410a117"
    sha256 cellar: :any_skip_relocation, el_capitan:     "59b46605118f8789c10facd53e9d4ce4c9f54c8de85611d423984c4316a169eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b75213c432ca3754d283de01029ae208a75955949c8b5b9e04613c9da943f8c"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", "-o", bin/"httpdiff"
  end

  test do
    system bin/"httpdiff", "https://brew.sh/", "https://brew.sh/"
  end
end
