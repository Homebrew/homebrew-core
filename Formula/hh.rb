class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.27/hh-1.27.0-tarball.tgz"
  sha256 "32d7ae015c9a055fd9d0e1dc3f946a851feb4f17fb777281e7c4602ba07b6819"

  bottle do
    cellar :any
    sha256 "7ffa119045c433257ecdae566d44cac9eec4a9ba9682083452eec22689b3a4f0" => :mojave
    sha256 "a1e2b478c301d6c582040bcc4f8f05efad260de69fac49e979305e0f7e9b3221" => :high_sierra
    sha256 "662118b81ed13840b804b8d22a850f1762465be491cf8132ffd8824fc46a2ec6" => :sierra
    sha256 "e19f7381ac79726f29069c21f95b0ad64f1d880e428765bebab40e8cfdfff426" => :el_capitan
  end

  head do
    url "https://github.com/dvorka/hstr.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_equal "test", shell_output("#{bin}/hh -n").chomp
  end
end
