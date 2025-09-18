class Libesedb < Formula
  desc "Library and tools for Extensible Storage Engine (ESE) Database files"
  homepage "https://github.com/libyal/libesedb"
  url "https://github.com/libyal/libesedb/releases/download/20240420/libesedb-experimental-20240420.tar.gz"
  sha256 "07250741dff8a1ea1f5e38c02f1b9a1ae5e9fa52d013401067338842883a5b9f"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d36e22ce4b36711d56c57c00138f650d3820cc868b00943efe923b85ab475c93"
    sha256 cellar: :any,                 arm64_sequoia: "19df457c00efc39b7ca068cdfa7beac035646a39c7e53e7112eeb00d1f222a74"
    sha256 cellar: :any,                 arm64_sonoma:  "4e0a0ca5c1634e6523359a2705b314e34d455b8c9403c9a471509202234fc19e"
    sha256 cellar: :any,                 arm64_ventura: "26c666149c74a54e744f41d18e75ab750b147a8f60ad14bade6beae81e1039a6"
    sha256 cellar: :any,                 sonoma:        "ca35e641f9022088e61dd568b98b928beac7247b6606a3dda6e5c925e6ded138"
    sha256 cellar: :any,                 ventura:       "85d5028c3fe1e6db45290397b9f5fd4773fdb70336058266a8f25e67b80e041a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07462cd653aae3448ae737536aebe605064ae7c75113dd467787fbc767ee8f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de46fa5de3819ee8025595a4579aac0982dcac0345302d6293228258bdee6dd"
  end

  depends_on "pkgconf" => :test

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esedbinfo -V")

    (testpath/"test.c").write <<~C
      #include <libesedb.h>
      #include <stdio.h>

      int main() {
        printf("libesedb version: %d\\n", LIBESEDB_VERSION);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libesedb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match "libesedb version: #{version}", shell_output("./test")
  end
end
