class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.24.tar.gz"
  sha256 "bd26e3dd89720ace1b003a43ab10247120b556ca106768fe8c829ee7bed6b435"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e303f97d906324d1f7eed7260a549e04f4d6bb780fcf9dcc6b183551d3f1ea99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7bcd3eedcd382e9c20261285f7cbdf054ecfb6ce86b096204018324619b5d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "918d68128a39d18f95f9105d6e27968ad5fff1277f6532d9b9d4f84b3de2c81d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bc8f1b9f0394fb7f0b69864d1d79fdeaa6d204031cd6f9fd9ad85888007b893"
    sha256                               sonoma:         "7441b5119962d987db294dbda9fed952eca07b43e039e153f8349db6e3c265c7"
    sha256                               ventura:        "d35a5d8d5a8e92a3b85676850c798d2619f4627ac71cc56b9e297ab8761be5dd"
    sha256                               monterey:       "f75a2e2c62f9a5885742025cc498f98c25d8e6c7f5a7540bb5055e3374314133"
    sha256                               big_sur:        "b73301d2334ccc872c2b16b2ab428f350b2b7de4c90a7c5211856faefc228058"
    sha256                               x86_64_linux:   "fb1fbf24c41c50352926682283cc177879c50d4ac36f9d786e01b1b2029a13c9"
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
