class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/refs/tags/0.12.tar.gz"
  sha256 "796dce1376f9bcb1a19ece729c075c47054364355fe0c0c1ebe5104d508c7db0"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3978ab782bb253378c31e91a018a64f5ebffd3f7094f7a731e47b09ed1424123"
    sha256 cellar: :any,                 arm64_sequoia: "3d5eac1ba12087334cafe44e836860f6ebe56bf82260e1347ac8c25dc9aa77ed"
    sha256 cellar: :any,                 arm64_sonoma:  "78ef36ee45540b936ac9fb73cf1098c915b60b5b55ee8fc9ef40d316ef47b5d7"
    sha256 cellar: :any,                 arm64_ventura: "d22ac68c3ffa78e14b36cc734c948dbf380689481536069e08a6b2c8321a152d"
    sha256 cellar: :any,                 sonoma:        "db969ba861eb8b3f5ffae7e2b4109005bdd423a3c91451b4676963bde403be13"
    sha256 cellar: :any,                 ventura:       "67eded8a3ba22bd10f8a5daeb46efa9b6a25bee8de81d50e93b8d02f9f7011f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d8961c5711101c3176712e1719b5ecb0df1c12533ab9afff6fe32d880ed390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8855baa30f090e94dce8a04af5f1e8e507e64a545ceb244c178934718b78cd36"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libsodium"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "expect"
    require "pty"

    (testpath/"homebrew.txt").write "Hello World!"
    timeout = 5

    PTY.spawn(bin/"minisign", "-G") do |r, w, pid|
      refute_nil r.expect("Password: ", timeout), "Expected password input"
      w.write "Homebrew\n"
      refute_nil r.expect("Password (one more time): ", timeout), "Expected password confirmation input"
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_path_exists testpath/"minisign.pub"
    assert_path_exists testpath/".minisign/minisign.key"

    PTY.spawn(bin/"minisign", "-Sm", "homebrew.txt") do |r, w, pid|
      refute_nil r.expect("Password: ", timeout), "Expected password input"
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_path_exists testpath/"homebrew.txt.minisig"
  end
end
