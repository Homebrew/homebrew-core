class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/llvm-18.1.7.src.tar.xz"
    sha256 "17ba3d57c3db185722c36e736a189b2110e8cb842cc9e53dcc74e938bdadb97e"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/clang-18.1.7.src.tar.xz"
      sha256 "c9191e4896e43425a8fbbb29e3b25b3a83050781809fbd4d0ad2382bc4a5c43d"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/cmake-18.1.7.src.tar.xz"
      sha256 "f0b67599f51cddcdbe604c35b6de97f2d0a447e18b9c30df300c82bf1ee25bd7"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/third-party-18.1.7.src.tar.xz"
      sha256 "8d8192598b251b44cf900109dc83dd9cde33bb465d7930a8cdadf5586d632320"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abd1c60015f98d815e4c7caa43078d879f4ef5433892e0b9994e580853ee31f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e394b01f96f60ab88200f5daac940d1f0ab856eb59c67d4a72ccc1631f2780e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1baf35822e58085f6a3aa57df5016553272e50f229f1888bb7e6f4e92050aa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a65356f1d2dd08942deb2408d77dddaaccba715d276c175ec3dfba49a247859"
    sha256 cellar: :any_skip_relocation, ventura:        "288da8a23bf97ef95621e20c699666d237730fd44d8174e30c37e7fe649cd898"
    sha256 cellar: :any_skip_relocation, monterey:       "ef38d7e682499479f01024624000ead0695703b434545457b769ff92c65337dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa0780cbd5a36faa46e9663520c437c77ac40788f354319cd56d18e5a31b7a0"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
