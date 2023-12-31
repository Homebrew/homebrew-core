class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "67d1a562d54b3b7622cc3164588c05b9e2bf8f1a5140bb48a4e816c61a87d4a8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f9ae5f0efca17061afa699b3e9e489e9cdc5c4a1367658c2dd771ab697820de"
    sha256 cellar: :any,                 arm64_ventura:  "5931fed281e39a795d5efcb0f796ef1b9d87ed6962d99d1e593a5360bf919c66"
    sha256 cellar: :any,                 arm64_monterey: "05f998084e702cf47c8db2b57b1ecfbb4339200f66e4279f5a0d343073ae76a7"
    sha256 cellar: :any,                 sonoma:         "7f80ae18ffe360b1d6f31d42d77cce95163d1ec97fde57b974cbee067f29a5bf"
    sha256 cellar: :any,                 ventura:        "313d8092a9f6e0e471e9a97dca2fdae70ceee837d141957bb092641cf5966b55"
    sha256 cellar: :any,                 monterey:       "ee2778193930dbae36b213362a4a7fa8f2aac300d2f570e3b3bb7b54271bbcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08273483bf1bc24ebef8145163d6e9fa050164951b20988a21829e40ebb8abbf"
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
