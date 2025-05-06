class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.7.0.tar.gz"
  sha256 "832be00ee71308c2a5eaa6918933d858e4ff8e062803d8a69a8aa97c361be6a6"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc19668b7d887750161602c4b0fb1edac87722cf0d63667c008005da4e96ae48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606c13c8073fd3cf02537018738cf3a2a3f96c27b1928edc46c5c02983444c7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d1a253f74d693eaa4fb12c9d4894c20f1e8af15dd74fec4cb82f6d2ce36e768"
    sha256 cellar: :any_skip_relocation, sonoma:        "415e7e545c1895bb2889212b3a192f2623f58a42ae2a4702a8939b612b9e0a93"
    sha256 cellar: :any_skip_relocation, ventura:       "713ffa6a42720004b4b91d7ae0da7ca6ddd016300852913f9387fedb84f92dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65bd6d5978813a2c753b434e94b80f9baef2eda669f4a31e6ecb56d16c61ff05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae21bedeceb61a35295a1450a6b796988b1a1e68a476dd6ad65440ecd0d67ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
