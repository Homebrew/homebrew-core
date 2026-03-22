class ClangFormatAT11 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-11.1.0.src.tar.xz"
  sha256 "ce8508e318a01a63d4e8b3090ab2ded3c598a50258cc49e2625b9120d4c03ea5"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1923e76a7a7db381a5aeec33e8b36b58dbc1894ed430bb0c0d2030b23351466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80badd34294c905914f5525552db99369edbeb249d6ef7ca418d9df12988acf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0b218f548e745af34b0652e5032bd6a526f36ce5e087fa907ea4d14700ebce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf417694a7860c8b13c14fbcb0c85734e909769a376a16af6af60c8ae85c4e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd3b2638563b5d8b649bd25f641713494eaca6117557f5c02e3eadb214e425c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8221c67cd82366a807f2efed7dc2e1d927e4865e6f2d06d8bec74089e30efd"
  end

  deprecate! date: "2026-02-18", because: :unmaintained, replacement_formula: "clang-format"

  depends_on "cmake" => :build

  uses_from_macos "python" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "clang" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang-11.1.0.src.tar.xz"
    sha256 "0a8288f065d1f57cb6d96da4d2965cbea32edc572aa972e466e954d17148558b"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install buildpath/"build/bin/clang-format" => "clang-format-11"
    bin.install buildpath/"tools/clang/tools/clang-format/git-clang-format" => "git-clang-format-11"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-11 -style=Google test.c")
  end
end
