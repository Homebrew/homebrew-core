class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "035f2c3cad4e45fc0d978c54a338c197d1937527ae6feb82180d428a96b83474"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9b549e596a3e4e1eaeedd569c32b68f235e54ba8713e1386651e7acc2dc0282"
    sha256 cellar: :any,                 arm64_ventura:  "2296f96f81246fdb45397253cd14f9cfa42c52f7035bde11e780520a278cf9d5"
    sha256 cellar: :any,                 arm64_monterey: "96f63a9d8704c1bf0b4f4526e814e80c33747e48567aabcc2a352fc39a5a2f1f"
    sha256 cellar: :any,                 sonoma:         "9b0ff494cc715d9fbdaf2145caa196800ee1c826f3768523736961aeceaa7964"
    sha256 cellar: :any,                 ventura:        "ac15271da11604c4ccfb6dcface753cb7590ddf0370f468acf29d1d5884cbd3e"
    sha256 cellar: :any,                 monterey:       "63107461e840eb1ff850ef03db7764ef0fada48408869af2a6fe1cc57a78fb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60fae62501dc36356a7328f9e50e7871ddf84fa6a46157d95c12edecd678b954"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
