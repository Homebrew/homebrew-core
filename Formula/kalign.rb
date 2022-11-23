class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.3.4.tar.gz"
  sha256 "f22fa45cbc5c81586d515ee6a77fdbb3704139dc8fdef83cc5f1596aafb59c7f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6b7cf192e20ecfe822900fc1cdb71e9bf559ef4c2808b6b1f7b0e2329ce3669"
    sha256 cellar: :any,                 arm64_monterey: "0183c78ad8d561035739573433b4b139c8695c85caed1af9430a1ec8731e9a32"
    sha256 cellar: :any,                 arm64_big_sur:  "8166c12b058ab9463b2b86c582493d719515fbd6b732a0f713c7f55fc6fd1c1b"
    sha256 cellar: :any,                 ventura:        "cab1cd3183cdeb5b0462643d8325b4641ebce6c3950479ac38cf9e48ab2acb58"
    sha256 cellar: :any,                 monterey:       "fe3dc31a53bfae01ee41106653f41428db61a797822ff108ce5b4379cc9709a2"
    sha256 cellar: :any,                 big_sur:        "7616559bef1a121f72152cfefc55a6e96e54bf435df093d6653d082ed7d474ac"
    sha256 cellar: :any,                 catalina:       "3f5c667d8ef7cc9d042691c85756d049edc531807f371c80b6bb3fed89db853a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3feb15659276f132a080cd0e7b638bcb1d9f6943e08c9b087d6d91195c8538ef"
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
