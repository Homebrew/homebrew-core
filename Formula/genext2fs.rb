class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "https://genext2fs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/genext2fs/genext2fs/1.4.1/genext2fs-1.4.1.tar.gz"
  sha256 "404dbbfa7a86a6c3de8225c8da254d026b17fd288e05cec4df2cc7e1f4feecfc"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3d9a117858748bd0a157e77968666936832bf63ff14d28850061a9b2ea68e95"
    sha256 cellar: :any_skip_relocation, big_sur:       "38f2b63de0f6754933416ff8cb8e8137cb59a1431fb0a0859c7439e0ddb18e01"
    sha256 cellar: :any_skip_relocation, catalina:      "65c723cefe5f0e2e70b2e23e217e9dc0c6ba0b8759ef6d50405356a34319875b"
    sha256 cellar: :any_skip_relocation, mojave:        "9a22f21cd781def8a9c4f89eee4158c1ad525766f2bb2d54aa1d00362c399706"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b74a72de535c529c5c5aa9ac3b77618e6f95f8114ded59e7e84124a829b6bb16"
    sha256 cellar: :any_skip_relocation, sierra:        "82ac8092d73d2f81fd0770b15bad060f4f3b010c089a0cda5131f9bcec3318ea"
    sha256 cellar: :any_skip_relocation, el_capitan:    "3842e46ce4c24b75364337fbe4a10243cd01a8aaf4b51feca6631c7cf0649aa6"
    sha256 cellar: :any_skip_relocation, yosemite:      "acdca2f9efcacafc7f105a43837a2f36e42dca1fd1325d62f9e5327797c69164"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/genext2fs", "--root", testpath,
                               "--size-in-blocks", "20",
                               "#{testpath}/test.img"
  end
end
