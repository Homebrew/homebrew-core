class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "1349790b2828a66f2f431fc34cfdd0499dc7ab159837e64a09b567c5f32523f6"
  license "Apache-2.0"
  head "https://github.com/energye/energy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8afbd8ee572eae65d3e17f96eaa191710809f7cd67d0dad4cc82f0d8aa22ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8afbd8ee572eae65d3e17f96eaa191710809f7cd67d0dad4cc82f0d8aa22ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8afbd8ee572eae65d3e17f96eaa191710809f7cd67d0dad4cc82f0d8aa22ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5731e827ecafd078095c83de6d2dd740ef05b7985dc47c489071dd2b9e030248"
    sha256 cellar: :any_skip_relocation, ventura:       "5731e827ecafd078095c83de6d2dd740ef05b7985dc47c489071dd2b9e030248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d984b4063f24bb65944a069730f0925aa56be4d992a8043488e983418cfc9846"
  end

  depends_on "go" => :build

  def install
    cd "cmd/energy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/energy cli -v")
    assert_match "CLI Current: v#{version}", output
    assert_match "CLI Latest : v#{version}", output

    assert_match "https://energy.yanghy.cn", shell_output("#{bin}/energy env")
  end
end
