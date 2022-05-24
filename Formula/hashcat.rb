class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.5.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.5.tar.gz"
  sha256 "6f6899d7ad899659f7b43a4d68098543ab546d2171f8e51d691d08a659378969"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fa6cfd37e7dcc83390159e971d314cde0af53ab58e41c8f669919d8db1acd1f6"
    sha256 arm64_big_sur:  "9407d08fda25cba3b7500bb0d6b99823b325f6b1302b96203b44d46052b43df5"
    sha256 monterey:       "2943213fd5cf7d331331d734c059efca5031ea913f434b9d3e420c9b89d32870"
    sha256 big_sur:        "50bbfbedcbbefcc4d0bda34f828eca5061a993631a4bae85d78abfe0b119556f"
    sha256 catalina:       "455a0e164a50caf10908da5ef73322bf19de286601a44a9e6e75d1ebcb010ef5"
  end

  depends_on "gnu-sed" => :build

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0 -D 1,2 -w 2"
  end
end
