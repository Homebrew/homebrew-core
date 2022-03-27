class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.8.0.tar.gz"
  sha256 "45a28655caf057227b442b800ca3899e93490515c81e212d219fdf4a7613f5c4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://files.dyne.org/frei0r/releases/"
    regex(/href=.*?frei0r-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbe34892f59b38e123a2749bc068933dbe1163427bc6124cdc7fad334fa04f57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "284401af98f9f86f7f4aa8dd2a2cd7ccd22841decc2065d730b9811cc683cd3d"
    sha256 cellar: :any_skip_relocation, monterey:       "682822c4f6f71ac68dc89db870e06dbdda7563a991652d3cc9b5808e3b818f74"
    sha256 cellar: :any_skip_relocation, big_sur:        "cafe9dbba970e60d275480465cf7f87b7847063fb2113e7fd862947de0735865"
    sha256 cellar: :any_skip_relocation, catalina:       "5076041b5f3d76b94866ab2b97ad34523ee40cfa314e6f7d2bf460ce304de872"
    sha256 cellar: :any_skip_relocation, mojave:         "5e23b93a7ff4a2ee64c5a969b17bf6a52329e6da17c0612b46aa2ceec3fb5b39"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a6a4648e1ff6263616f532a4648e1eb56e68d510d04e768becb2caf5ca961e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd92d047a4e4cf723f8b22eb120622bd026d7c016316b7dd15c61f787ca93924"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""
    cmake_args = std_cmake_args + %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
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
