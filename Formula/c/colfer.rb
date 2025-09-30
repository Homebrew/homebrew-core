class Colfer < Formula
  desc "Schema compiler for binary data exchange"
  homepage "https://github.com/pascaldekloe/colfer"
  url "https://github.com/pascaldekloe/colfer/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "5d184c8a311543f26c957fff6cad3908b9b0a4d31e454bb7f254b300d004dca7"
  license "CC0-1.0"
  head "https://github.com/pascaldekloe/colfer.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6753b9901bb37c362353210bd3fb81d2330d08285934c9fe54f79abdf644cd2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "46194d5083a34ae3e54cdd690610c1dd5fa385e2311cb1bd61e852029a53ec85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8310235bd0dec3a5cb4464aa1cd9c2ece726e5ef0100c9fb80f6443507e273c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea5a224dfc033cc2a6e2bce8e9f55add8735770539d5db1e4787902594b92a7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf8074276dffcfb264832e08687f3dcb0618ff7f51806bfe0b316983c08a186a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e909fd6305c6b00a1499756f250666ccb80a285b2cd1115aa95edb6e31593ea7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d38a815f95a05e91d15d094baa7f760c02195758f3a95488b3f48866b6336a55"
    sha256 cellar: :any_skip_relocation, ventura:        "a625b32ffe11cfdbf95699c28f73d5ccceec37b0d2fbf1fae720d41e55be902a"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4fd7e02a61239f90e3de47e6016ba6cd9c89d31c7728a1a857be854a85add2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ee59a49a4e15f40a620d526039cb8ef82e5c323f59f6df3074f1aa153c3fea4"
    sha256 cellar: :any_skip_relocation, catalina:       "dfdb2743960de62ee18ab35a7ead3d2d8de4207cc6ffa11ff0d8ebf393a591e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ce8f82ed2dc94b3000d7d4f591058affc15e693b64e62204b39b012915f9068e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e68acefc34743620979a02b3adce372b7a0a0a93c0e3a6c51480bfa2c02c29f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"colf"), "./cmd/colf"
  end

  test do
    (testpath/"try.colf").write <<~EOS
      // Package try is an integration test.
      package try

      // O is an arbitrary data structure.
      type O struct {
        S text
      }
    EOS
    system bin/"colf", "C", testpath/"try.colf"
    system ENV.cc, "-c", "Colfer.c"
  end
end
