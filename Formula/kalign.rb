class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.3.4.tar.gz"
  sha256 "f22fa45cbc5c81586d515ee6a77fdbb3704139dc8fdef83cc5f1596aafb59c7f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d0e240deabf797eb8c7549c3ab8f9826f151e17596755e9df19a9b07270c64f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e94de66c1446c71dc011d3f7164a146aa87248d492e2e18dc3fa2b5e8476ebf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88e2edbb2dbceaaf17f29c3f3ce58cf012686247923e54b7299c3323aaabf90d"
    sha256 cellar: :any_skip_relocation, monterey:       "a58c610fbbebd1914416856971578afa00d18075b762ba620cccc63ab0cfa367"
    sha256 cellar: :any_skip_relocation, big_sur:        "c10c59f171b19111664704c90721b786a655b0b36870fa33cc955b54948c7289"
    sha256 cellar: :any_skip_relocation, catalina:       "32eba73efa58824f18f56eba12176d0494d8455beab2983513092920147969b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9fa5d98ca2c31bcf8d24805ac30764d59154fb902a5378f1e2cca8f1e2bb085"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DENABLE_AVX=OFF
      -DENABLE_AVX2=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = ">1\nA\n>2\nA"
    (testpath/"test.fa").write(input)
    output = shell_output("#{bin}/kalign test.fa")
    assert_match input, output
  end
end
