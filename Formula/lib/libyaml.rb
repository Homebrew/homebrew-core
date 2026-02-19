class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/refs/tags/0.2.5.tar.gz"
  sha256 "fa240dbf262be053f3898006d502d514936c818e422afdcf33921c63bed9bf2e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5cd5a1875da18599e25283465b2fb8735eb8717ee7158ef17f8f4260205404f2"
    sha256 cellar: :any,                 arm64_sequoia:  "0ec9bf8082245c008803b42dcae3e6a0c8cd7a67aed589d9b6482b115c0a543b"
    sha256 cellar: :any,                 arm64_sonoma:   "98c0cf81bcdf7577d5fdc8cc18732970b9ae7e0e7423a733f88f0f566ba483ad"
    sha256 cellar: :any,                 arm64_ventura:  "11239e8f5066c6d0d0718208d4eab518da00c7289f33c9c76c0a09ba5c0417c9"
    sha256 cellar: :any,                 arm64_monterey: "a436da33a05f805258c5951a365dec4e8d70a908dbe5dacdeb6b2ecd0efd5024"
    sha256 cellar: :any,                 arm64_big_sur:  "fe1082f3475a144261b41e2c3e0728b9331911b1cbfadfbc1f3d70d454709154"
    sha256 cellar: :any,                 sonoma:         "4d6e02ce3a82b60033bc7e55bef841dcfef0c05c051176d96accb50744136c6d"
    sha256 cellar: :any,                 ventura:        "b49e62f014b3e7d85a169b422b7521356700c7caaaea9f4901086cafe692a86e"
    sha256 cellar: :any,                 monterey:       "dbd54ce703c6d8eb77e708f75b4730ad2653d28f6291c4a26dc22158beb3f210"
    sha256 cellar: :any,                 big_sur:        "83547fba540a38c30705a59a2e746952c68857212e823c6ee97c186e088f75cd"
    sha256 cellar: :any,                 catalina:       "56d3549b342cffb181e3eb05356697bbb362b9733c73e0eeff9b637ecf92cd23"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c725eb08fc7ab6aad7f744a30b230f9b9efa33f8d694849a2d4aadfabb203df3"
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
    (testpath/"test.c").write <<~C
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
