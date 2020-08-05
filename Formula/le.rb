class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "https://github.com/lavv17/le/releases/download/v1.16.7/le-1.16.7.tar.gz"
  sha256 "1cbe081eba31e693363c9b8a8464af107e4babfd2354a09a17dc315b3605af41"

  bottle do
    sha256 "704e7762fb13634aa7b2fe4cc271747894d8ffcf5028abd0d27497bceb6bc378" => :catalina
    sha256 "aa1144661f13ab5fbe4eb132415da66785ab1b903c8d517df03f40826d08632f" => :mojave
    sha256 "b6fad9458d040f9a47a0d3ff003ab5f77cdb9508a5b653c3cddc201cfb5310e2" => :high_sierra
  end

  def install
    # Configure script makes bad assumptions about curses locations.
    # Future versions allow this to be manually specified:
    # https://github.com/lavv17/le/commit/d921a3cdb3e1a0b50624d17e5efeb5a76d64f29d
    inreplace "configure", "/usr/local/include/ncurses", "#{MacOS.sdk_path}/usr/include"

    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
