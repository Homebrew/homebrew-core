class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R57.tgz"
  sha256 "3d101154182d52ae54ef26e1360c95bc89c929d28859d378cc1c84f3439dbe75"

  bottle do
    cellar :any_skip_relocation
    sha256 "0028f1d8028129a398937bed7fb3b2f7608932386d116d1b05527ff266c3470c" => :mojave
    sha256 "d666938f31f5c9e5a0dd4b5f0e823ca7d5f2015cc447284ff0204cdc874d70e4" => :high_sierra
    sha256 "1fbdae63a63116e3a321b71d632214ea2419d404db8939f7cb3471a2de35c761" => :sierra
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang) ? "lto" : "combine"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
