class Litmus < Formula
  desc "WebDAV server protocol compliance test suite"
  homepage "http://www.webdav.org/neon/litmus/"
  url "http://www.webdav.org/neon/litmus/litmus-0.13.tar.gz"
  sha256 "09d615958121706444db67e09c40df5f753ccf1fa14846fdeb439298aa9ac3ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd55b54482009ae82c55532f45fa5ef054688fb2df5685eadf4b7a3dbcb8b1e3" => :sierra
    sha256 "10a49ffd5dfde15e35effdcf51ba8097086294e33fb7cb7fab65628c03cdef3e" => :el_capitan
    sha256 "07ce12b82b1a1bb63c9c0c596a7fb3f577afb369b87b4d6bce23e97fae9b610f" => :yosemite
    sha256 "c9fd308d0d348619c8af1a5f95c4f129734fcc07e2b3eea1151fbadd89225b94" => :mavericks
  end

  def install
    # Note that initially this formula also had the --disable-debug option
    # passed to ./configure.
    #
    # This disabled a critical feature. Litmus is a debugging tool, and this
    # caused all logs to be empty by default.
    #
    # See: https://github.com/Homebrew/homebrew/pull/29608
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
