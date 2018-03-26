class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.12.0.tar.gz"
  sha256 "ccaed676a7847becc045c7491b47ab3e218ab7ed7fe937d222e3cda796ab25e3"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "251737581e344598c0b9138d243899a0e08ae940084388ba3a23474938015b13" => :high_sierra
    sha256 "5fbc1bbad070e0b24a4ada2013c629a9fae110d7600411d350324a2a4aa36a67" => :sierra
    sha256 "431bcc466939eae736db3f6212b2eb768b4ce18cf80c493a78f116a94758735d" => :el_capitan
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
