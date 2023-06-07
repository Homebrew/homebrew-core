class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/v4.0.0.tar.gz"
  sha256 "02a88204fe36428cc6c74453059e8c399759d4306e8156d0920aefa4c07efc64"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ac6ed1ef416a844bd9794ef1810bebb3bd24397e7ed4f1aac754e8842b0600"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c7cbb01fe420183e802a5a974d5eea39f38333469674f8128d74db49376a726"
    sha256 cellar: :any_skip_relocation, monterey:       "473cc7a5c1ea7ef3bdd0e196022fc3f8941424f0cd6e80af44ecfe64c92d4952"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1fc773f5452ccb165e28e9ec0a79616c14ababc66ed3614a213bc86bbfcda84"
    sha256 cellar: :any_skip_relocation, catalina:       "792f1b46b5f17933b21ec7adb62cf0b6add03ef94e8a73e5e691e12e9aa85049"
    sha256 cellar: :any_skip_relocation, mojave:         "4629398ca4b1bf5cf7779b8d5c9e6f066ea5e96f66063c265f0b13e106a0cba0"
    sha256 cellar: :any_skip_relocation, high_sierra:    "05387acf4adf651aaa011d02f5a08ddf49725a550440cc7eb496c1112166852b"
    sha256 cellar: :any_skip_relocation, sierra:         "14fc35b7b932170333d8260b8bda881844ffc68870aeb1a120ebd74072ef900c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "209c4c475fa58cb42a2e98bd34c11a983463465ce4ee5470474177d6740fb2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1e3a47564c136eedecb087617ebf7b7b9da158d0eef5497cfd04b5ffa74d814"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.cxx11

    # Build internal Clang
    mkdir "3rd/templight/build" do
      system "cmake", "../llvm", "-DLLVM_ENABLE_TERMINFO=OFF", *std_cmake_args
      system "make", "templight"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.hpp").write <<~EOS
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    output = pipe_output("#{bin}/metashell -H", (testpath/"test.hpp").read)
    assert_match "const int", output
  end
end
