class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio/"
  url "https://downloads.sourceforge.net/project/asio/asio/1.36.0%20%28Stable%29/asio-1.36.0.tar.bz2"
  sha256 "7bf4dbe3c1ccd9cc4c94e6e6be026dcc2110f9201d286bb9500dc85d69825524"
  license "BSL-1.0"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4cec14f252d40fbbc1ef0d874509be5a609f3788f78bb3ac6dcad5919f5fbaa"
    sha256 cellar: :any,                 arm64_sequoia: "5023e595b55a6c4abd2f453de043aea03696ac9fc5b38d093c9edcf8df86383e"
    sha256 cellar: :any,                 arm64_sonoma:  "01a303e1e836fe0d76d87ef28370a5f8c44317146d2bd7e4757e7dc9369e490e"
    sha256 cellar: :any,                 sonoma:        "f769bb83a89a879cea0c60e873ea822900b8830546be64e4beb93a873eca12ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b90e36ecfd0ca13d53f436ffbecf504a543bd2b5e1dd3a1e6c79826d10085201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2366bd7dbcf813b7e7c52d6d1d1cb11c4bc9ea37f68b35a0afefa833666d870"
  end

  head do
    url "https://github.com/chriskohlhoff/asio.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@4"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    end

    system "./configure", "--disable-silent-rules",
                          "--without-boost",
                          "--with-openssl=#{Formula["openssl@4"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = spawn found.first, "127.0.0.1", port.to_s, "."
    begin
      sleep 5
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end
