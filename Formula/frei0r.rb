class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "dd6dbe49ba743421d8ced07781ca09c2ac62522beec16abf1750ef6fe859ddc9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9377921bab7290f44ee4851e67ee2edef807be0fb221156695c27682ed5c04d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c31413ef3e76554d9f625db882f844945e70dfeecd0fc0a9f806448418f7d10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89d7fa7a43cb0197d5f02308584a3c1ef85094904dde22d25c16285991258789"
    sha256 cellar: :any_skip_relocation, ventura:        "d72f91bc351a162d041b4fbf46fb5244d09a84ecdee25f94a4fe931e05eabef4"
    sha256 cellar: :any_skip_relocation, monterey:       "22f0cb824fbcda47a91645cd5e3782050a7adb1faa804ba115f0ccb8c6990447"
    sha256 cellar: :any_skip_relocation, big_sur:        "85733d5d2a2f38e1d9dc9043a600b4567913f115a2920fd3939dacdbec6afd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823095d9928500f908ed3c1798c54aa3096daad87883d5a468449686cc3ce244"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""

    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
