class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.2.tar.gz"
  sha256 "77c12d80bb76fe774b16996e6bac6d4ad950070d0816c3409dc0397dfc62725f"
  license "ISC"
  revision 1
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "651dadcfc4d6ef192a3c6834d817fb184c369c0558113283a18a0cd45d6cd90a"
    sha256 arm64_big_sur:  "843bee8be9b432353e81f244ce58a85cc190c7c28559a0f7ba61fa34ef7dd5cb"
    sha256 monterey:       "e27813f97e1239b6d07e9c936acb3dd72b6e37499d427cd61b31e956ec7c59b0"
    sha256 big_sur:        "b6b3ab72bc73bb9aed91e64f4118f80feb73f1f9416f66ca5817f533f29772f5"
    sha256 catalina:       "b4b39605d30bd4b7b5159ab40b2ee49d6043ba63822de4fb16c66fbfddabb26e"
    sha256 x86_64_linux:   "e94b9fd5e6039cffbac0e88cb1fdd46a00d22cfade31ac6d30a2b270ea438d67"
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"

  def install
    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
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
