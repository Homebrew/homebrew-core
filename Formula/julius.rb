class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/v4.6.tar.gz"
  sha256 "74447d7adb3bd119adae7915ba9422b7da553556f979ac4ee53a262d94d47b47"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "4b8251857584f844fe5469a0283a773428383053f8d80eaeff885b745578aa1d" => :big_sur
    sha256 "b06b9ca71df4cccff10e36a4a75a55f7d5bdb009f4dba9f940044da6ba0c258d" => :catalina
    sha256 "041d7a3185850375ef67148a74ab9513e9a4eb6de05deeb3595f3941c41010d6" => :mojave
    sha256 "d699dbf645c69f795421569e21c9d676e0db534a8d72fabfb721d5864e391549" => :high_sierra
  end

  depends_on "libsndfile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius --help", 1)
  end
end
