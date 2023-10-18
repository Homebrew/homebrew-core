class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.3.5.tar.gz"
  sha256 "75f3a127d2a9eef1eafd931fb0785736eb3f82826be506e7edd00daf1ba26212"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fba208e9aff5e1fd763e9e333e42fd35e3330118f11be22c2ec04e5e4c6df50c"
    sha256 cellar: :any,                 arm64_ventura:  "5635f39d21c03d166f1f2b603618772cfbf40b5ef868ff819992d25ffc0540be"
    sha256 cellar: :any,                 arm64_monterey: "d2834f77050ed2916a4e52b62453c600db111bcf9f4dc5170ae0a0b7bf59ff2d"
    sha256 cellar: :any,                 arm64_big_sur:  "b34f64c5649ab5d5f72f8575f321444576e07012de69ce4d4c8d2f962c75189d"
    sha256 cellar: :any,                 sonoma:         "9ab34978cd584458f792cc572ad5148fd536a8fbbf5dc1e487a57843d276cbbe"
    sha256 cellar: :any,                 ventura:        "0f376ff405014200846681aeff10fbee9d65b00716cbc9cc7d655bd271b2a78d"
    sha256 cellar: :any,                 monterey:       "01494d9ee7590e523f0de5159c556ff10bd98c03694920d1097e1dc42caaf695"
    sha256 cellar: :any,                 big_sur:        "c71ad33602a96d843159ce93f7978a2cd274172eca84643a1ee35808e402c2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a5c4aa4f551894d47d61203c727d204bfc4d7c246cd1b050f6fb04d1e950906"
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
