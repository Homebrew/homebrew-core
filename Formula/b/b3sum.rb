class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.1.tar.gz"
  sha256 "fc2aac36643db7e45c3653fd98a2a745e6d4d16ff3711e4b7abd3b88639463dd"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46b779fc019d3bcbaa9e59d73cc5931ccb60624fe072650622169d0320e20cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab916b2964da945abe2852bf7efb1011e185e33a9f62e90b3bb13007df18caee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a928cc6f69417e59d7171e059bebc5e75548b6c3448659d3e1864de8f02289a"
    sha256 cellar: :any_skip_relocation, sonoma:        "563d2c084f78d2164c14124293357cfbe947f46279befb0cfa752176de2d348b"
    sha256 cellar: :any_skip_relocation, ventura:       "e03c959d5a2a24c6202e52cd9f23f2978b2f2c2a5c991f5d4ac91e636228854e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1fa3cab025e41c22583381feafabbecf11bd84086cd75dcc757875444234e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c69ea20e5e51324aea5d049a2a5f9bdca64030604be9bfb2b4b8f53134e32b"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
