class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.5.tar.gz"
  sha256 "db778110891f7937985f29bf23410fe1c5d669502760f584e54e0e7b29e123bd"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98745c9a59dcf0e9894493ad047699171d5ddb4d943115e94d08b58e21c484dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12e8257cfc5dda342cf5df3579e4d75d6c7da1c3e5188ea2bd632f66ca9291dc"
    sha256 cellar: :any_skip_relocation, monterey:       "0891342216aaba226425c2e27a21082f1096994e6be82cebb08eedb7c4d9fb76"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7eafa8a473d2bfd1d9fbc207ed863d5765189b6662341420bee8a78cc6d4360"
    sha256 cellar: :any_skip_relocation, catalina:       "b7ab66d5cea5b77081f58392eb8f8c66341cf20c94739a77c262f0a1f54716a6"
    sha256 cellar: :any_skip_relocation, mojave:         "b7db705a81f667bde21d234b7241d9e0ae0643e9052aa836196095bbd4e98dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947fffdc8681c896ef07de1dabbd69341458de8d37c106d706d6013942d156c4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libedit"

  def install
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
