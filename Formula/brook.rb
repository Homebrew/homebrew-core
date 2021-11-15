class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20210401.tar.gz"
  sha256 "6229b2f0b53d94acb873e246d10f2a4662af2a031a03e7fb5c3befffcd998731"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0d971d55c3c597c79d9b7ac088c76429015bec888354c1a99103af9ab88a021"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae611e972e986ae0d8f868e4e179320b120e34abcfa32e1e07449709b1eff0e5"
    sha256 cellar: :any_skip_relocation, monterey:       "02dcc8ff9f5af8bd607e4a996d50ba4d0d3dfa5d5126334f9471d8168ae53819"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b0661f65db2b397e6dcf36b84b649e383835cf38df778a54ba95d9c8239dfd2"
    sha256 cellar: :any_skip_relocation, catalina:       "d3f484395c5fbf6c218b359ab37be696be4c8277b5cdd8b1441950755f62cac1"
    sha256 cellar: :any_skip_relocation, mojave:         "082279557c3e15d460334a8a7f5f0f028bd7ec0aa7328a7cd7e5149a4ce029c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062e4fbf5db1df0bbe66de05086a0bd054047a4a1dcc1870bc36e30024d884ea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    cd "cli/brook" do
      system "go", "build", *std_go_args, "-ldflags", ldflags
    end
  end

  test do
    output = shell_output "#{bin}/brook link -s 1.2.3.4:56789"
    assert_match "brook://1.2.3.4%3A56789", output
  end
end
