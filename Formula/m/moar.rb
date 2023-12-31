class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3b10f6898b17360344b4dac58111a2328eca5cb19bc246eb56bdddc04aa2b0af"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a8b2cde00032b001f8e86bcf30113130560a0ad0178d894e293aa4fd151c924"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a8b2cde00032b001f8e86bcf30113130560a0ad0178d894e293aa4fd151c924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8b2cde00032b001f8e86bcf30113130560a0ad0178d894e293aa4fd151c924"
    sha256 cellar: :any_skip_relocation, sonoma:         "64baee2d0e9af0fa729c70ce6390e9aa22c15b966ae33a93b22d0a00d9fc27da"
    sha256 cellar: :any_skip_relocation, ventura:        "64baee2d0e9af0fa729c70ce6390e9aa22c15b966ae33a93b22d0a00d9fc27da"
    sha256 cellar: :any_skip_relocation, monterey:       "64baee2d0e9af0fa729c70ce6390e9aa22c15b966ae33a93b22d0a00d9fc27da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b16ab859aa9338c851cec6f3721467c61e8981250c2feb8ed45a3c31ec1a8b6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
