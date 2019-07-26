class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.24.0.tar.gz"
  sha256 "b4b1b36786fd55be829a6b0a42771d9134152b503dafa92ee0f2c6e57c8cb3ca"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "09cb6e88959cae462136493836a0ebf496a9fc50b2f478b281b3f1fe4767fdf0" => :mojave
    sha256 "b2eac1a03c217e6276bf5a654203976baf03d2467d51f453180dbb00223e0a13" => :high_sierra
    sha256 "1a3048a8e8630034be48bfd4ffb5fd5c71bb2cebc9dd2b54ad6e1d79c7fc95ff" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
