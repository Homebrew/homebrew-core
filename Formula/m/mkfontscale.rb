class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.4.tar.xz"
  sha256 "a01492a17a9b6c0ee3f92ee578850e305315b9f298da5f006a1cd4b51db01a5e"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bf96e2f1889d39f29c6732ae5199503fc11de4c02c658748909af183aad0953"
    sha256 cellar: :any,                 arm64_sequoia: "82f78c357339cc9200ce7a80c4b4289fe5b6e53b7aaa50c36861be5ab2222a6e"
    sha256 cellar: :any,                 arm64_sonoma:  "0fcd32b02623dc4f981d924163af62af62cb95104eef22b5221221376c4464fa"
    sha256 cellar: :any,                 sonoma:        "45f16d946c3ed20222f3be602426752143bbc498c3a5a173e94437cb0305eec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b524bea7fa6210a2ae29b2165700359a8b801005407100817216d5fa031bdfd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4afa3e0f3b2d817d818e2d8620add591150f0161e26e2466245788c099af73a2"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    configure_args = %w[
      --with-bzip2
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mkfontscale"
    assert_path_exists testpath/"fonts.scale"
  end
end
