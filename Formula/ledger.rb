class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.3.tar.gz"
  sha256 "b248c91d65c7a101b9d6226025f2b4bf3dabe94c0c49ab6d51ce84a22a39622b"
  revision 5
  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "9b9be8385bbf69fcd7e910bce409f97c08542b89aecacde4d615d5a5ca9af65c" => :catalina
    sha256 "f36940017c56792a42d010b1b1094d355575adb4d51f74acaf4ea8e57024aba0" => :mojave
    sha256 "a8313d55f2a5070ac82c01260c11a77273c5dc6d0ee2c38d06eb0b9a143cb5cb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.8"

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
    ]
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
