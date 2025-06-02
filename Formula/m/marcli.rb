class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://github.com/hectorcorrea/marcli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "673f3237baa843db13f671c5a2e3986aa272566a38835bdd042377327ff9d9cb"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094b57f3f543ddd6cfdbe59ae3471ff70b5c1558290d0af936274d47c02e7a01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094b57f3f543ddd6cfdbe59ae3471ff70b5c1558290d0af936274d47c02e7a01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "094b57f3f543ddd6cfdbe59ae3471ff70b5c1558290d0af936274d47c02e7a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7d0a23c4c74f8067d2019c713baecf5d1217c10b308dc5fb95b7005aa9d2228"
    sha256 cellar: :any_skip_relocation, ventura:       "a7d0a23c4c74f8067d2019c713baecf5d1217c10b308dc5fb95b7005aa9d2228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55d7013246601fa973521af7319642cd92b6a0b1bf911867fe9e215f19999159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ff92374dc575521c6033af290af42f3cb52cf092035c740f79bd5afa43c966"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/marcli"
  end

  test do
    resource "testdata" do
      url "https://raw.githubusercontent.com/hectorcorrea/marcli/5434a2f85c6f03771f92ad9f0d5af5241f3385a6/data/test_1a.mrc"
      sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
    end

    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\r\n=650  \\0$aCoal$xSampling.\r\n\r\n",
      shell_output("#{bin}/marcli -file test_1a.mrc -fields 650")
    end
  end
end
