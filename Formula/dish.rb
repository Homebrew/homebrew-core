class Dish < Formula
  desc "Tool for parallel sysadmin of multiple hosts"
  homepage "https://freeshell.de/~drimiks/gnu/dish.shtml"
  url "https://freeshell.de/~drimiks/gnu/download.cgi/progs/dish/dish-1.19.1.tar.gz"
  sha256 "eaddd3f97240f00714879cfa6e279a652bc2afad106ff1da6c5083ff27af3bf0"

  def install
    mkdir_p bin
    mkdir_p man1

    system "./install.sh", "-i",
                           "-b", bin,
                           "-m", man1,
                           "-q"
  end

  test do
    output = shell_output("#{bin}/dish -p0 -e echo root@localhost").lines.map(&:strip)

    assert_equal "spawn ssh root@localhost echo", output[0]
    assert_equal "ssh: connect to host localhost port 22: Connection refused", output[1]
  end
end
