class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.10.tar.gz"
  sha256 "d4c90c17cfcd44aa96b98237731e4f811e071d4c2052a689d2d81e6671f571b1"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "004faa12fdd3db1914ce0421c0c2e03ae1b82295d5e2d1cfdc68681e366be2eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bfb8b5841df46f8bd32f7e2cb9bd03af62a3e9b8617fbcfeecf84d7ab6769f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "701476576b7084c588eb4e10aca427231c812cd75321fbee9ca2185723ead6c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "53d9b52ea085a7d7e12f9a6b2c2916c41e746e702cb84bcd21cc19b55329e908"
    sha256 cellar: :any_skip_relocation, ventura:        "a8b8f98b51a1ae4d0ec6f84b2df1b8b3487123ef25b14e8244286053cadb3653"
    sha256 cellar: :any_skip_relocation, monterey:       "b015d9f5d346126e92bf11ffa799d40c585f1e3f5f2e952604a7acbce175b072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c15eece234ed08b4ff463ef219b9306d2c549e3bce295c1a4ca4d81516da0bbf"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
