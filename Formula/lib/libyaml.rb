class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/0.2.5.tar.gz"
  sha256 "fa240dbf262be053f3898006d502d514936c818e422afdcf33921c63bed9bf2e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11239e8f5066c6d0d0718208d4eab518da00c7289f33c9c76c0a09ba5c0417c9"
    sha256 cellar: :any,                 arm64_monterey: "a436da33a05f805258c5951a365dec4e8d70a908dbe5dacdeb6b2ecd0efd5024"
    sha256 cellar: :any,                 arm64_big_sur:  "fe1082f3475a144261b41e2c3e0728b9331911b1cbfadfbc1f3d70d454709154"
    sha256 cellar: :any,                 ventura:        "b49e62f014b3e7d85a169b422b7521356700c7caaaea9f4901086cafe692a86e"
    sha256 cellar: :any,                 monterey:       "dbd54ce703c6d8eb77e708f75b4730ad2653d28f6291c4a26dc22158beb3f210"
    sha256 cellar: :any,                 big_sur:        "83547fba540a38c30705a59a2e746952c68857212e823c6ee97c186e088f75cd"
    sha256 cellar: :any,                 catalina:       "56d3549b342cffb181e3eb05356697bbb362b9733c73e0eeff9b637ecf92cd23"
    sha256 cellar: :any,                 mojave:         "a04988b3868cfadf7bcaff6b753b59388cbea70b38f2fa41a25229150d073696"
    sha256 cellar: :any,                 high_sierra:    "d3e22ad09c3d6872c5f7ee7c7f1146c9f14c178ff4c3a3488a20bf584bc854d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354677a745b6c62109e792ddbd0cbdaf9e6a471d84fdbde3a7d9bae36d832da8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
