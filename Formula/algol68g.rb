class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.2.0.tar.gz"
  sha256 "964a32a39de074dff235d2baba21e2b31c8b1855a537b98c62cc36cceff8bf89"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afc3b8ff8b5a969ff129623054e1b059fbcc5099a6c5835b97bd13da405cf6e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b27cb5841590c48dabfa326ab947b3a16485493e97699cfb5c5fbb2be362041"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fda42b9db2b6cffa006b10a1e5c4b104225a269f9771aeb878deb2bebd465718"
    sha256                               ventura:        "67a0f0cd20615017b46a398930cebd5763bd7832e9cede57f8004cf669c9138d"
    sha256                               monterey:       "ce6a62d4dc62af204c4e0772bd1dbd9d8574802646788429d28c69e4f8ed4bf1"
    sha256                               big_sur:        "1cf9c0988c8aa230033d643584c53ac1062715937b93a2a7352e0f071f65ff5d"
    sha256                               x86_64_linux:   "3dd95d84e8b251177269c81b31b90e1d63d2c28574e0ed478d9b341f17666554"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
