class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.1.0.tar.gz"
  sha256 "b7d73b005fde0ea01c356a54e4bbd8a209a4dff9cf315802a127ce7267efbe61"
  license "ISC"
  head "https://github.com/jorisvink/kore.git"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "1e10262c090ee11466ccf64510ec2bc443698e39b6b05edf3defc09c89499f71" => :big_sur
    sha256 "ecda8ffd811a6ce1c1b0e501a0c17d2518325b202029729ab1c26f60b5e28793" => :arm64_big_sur
    sha256 "ad77b830ab7265b3f1f3be5f25b82949672369ab53478b35428ccc39dc770c5f" => :catalina
    sha256 "766a72d1382f2edff8a4a479e6528fd3b3e952b978224d139dd1c602ea9c39c5" => :mojave
    sha256 "f474c6f87252bf4e96ea2c14db3d10246b91bfb41ab366fffb598649366317be" => :high_sierra
  end

  depends_on macos: :sierra # needs clock_gettime

  depends_on "openssl@1.1"

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl@1.1"].opt_include

    system "make", "PREFIX=#{prefix}", "TASKS=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
