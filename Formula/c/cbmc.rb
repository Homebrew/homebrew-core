class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.7.1",
      revision: "d148ae6e880a3ef167bb71e9ed28169578899dce"
  license "BSD-4-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8eb1a58c31b2d9e058603bc51256b2afa472812b6e12a80147f8fee69789cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3b37f03018ca7726d7aea58b6764e21e56bd5e634541741e4a68bb783d1c44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bcf9127d1034a739e807d8397cfa2809a94a3285a045b1d3c82aac8104beed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fb85f758134ea23ef3c6bdd617fb3af20c4142f913f6add2073e1de4446d7e2"
    sha256 cellar: :any_skip_relocation, ventura:       "6a17570d917844ac3345bc76dd4ed7348277ed57dec7d51b40f67731b63bb43b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de45dce8bac8c72bc9259c0bf60d2bea6bcc4330b1b01bc4af0a78293f6f5c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd031a9018c40d31592c3ce172a2499f58d0e5bc5c63ac812ce5431e7c9d480b"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Fixes: *** No rule to make target 'bin/goto-gcc',
    # needed by '/tmp/cbmc-20240525-215493-ru4krx/regression/goto-gcc/archives/libour_archive.a'.  Stop.
    ENV.deparallelize
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
    libexec.install lib
  end

  test do
    # Find a pointer out of bounds error
    (testpath/"main.c").write <<~C
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    C
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end
