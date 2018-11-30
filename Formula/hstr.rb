class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.0.tar.gz"
  sha256 "8d93ed8bfee1a979e8d06646e162b70316e2097e16243636d81011ba1000627a"

  bottle do
    cellar :any
    sha256 "318da53b6a2415308236b2de23c3233984463bdde6ba3e534ec51ea1337615d3" => :mojave
    sha256 "129664d7ed61d770c4257cb6c62ce374494dd7c11bb0ce5ff23540cb999b7329" => :high_sierra
    sha256 "96ad8bad0cb4913cee6ef44442363d98f36e358adaec18d560f193f9ccad117c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
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
