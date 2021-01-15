class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.17.0.tar.gz"
  sha256 "80657aa752322560fcde780212b6807b626b45d65aca3f3dae254e5c4fb0ee78"
  license "Apache-2.0"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e946287a71eead01b620d34ffe99628a5bd143951265bbae9de6288eaf124bb0" => :big_sur
    sha256 "a1210dda91aa024d11bd4d15a67b71654dcbbbc2ba14a87d1d34ab012f4d5c2a" => :catalina
    sha256 "a3a37fdf8f0e99efdfc1736978ea9d8cdea74e939b42696fe771c3c5c9914f8f" => :mojave
    sha256 "2c704b1f98b965c0b6010a897a0c951f47cb896bbbf5381e7d4ee80238692033" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # To update this resource, check LIT_VERSION in the Makefile.
  resource "lit" do
    url "https://github.com/luvit/lit.git",
        tag:      "3.8.1",
        revision: "27114d94b9299437b2229eac6a6c3a9ef41fa83a"
  end

  # To update this resource, check LUVI_VERSION in
  # https://github.com/luvit/lit/raw/$(LIT_VERSION)/get-lit.sh
  resource "luvi" do
    url "https://github.com/luvit/luvi.git",
        tag:      "v2.11.0",
        revision: "9da12caaf01337ef0609d07b2af9a5296c13922a"
  end

  def install
    ENV["PREFIX"] = prefix

    resource("luvi").stage do
      system "make", "regular-shared"
      system "make"
      buildpath.install "build/luvi"
    end

    resource("lit").stage do
      system buildpath/"luvi", ".", "--", "make", ".", buildpath/"lit", buildpath/"luvi"
    end

    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end
