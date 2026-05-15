class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.2.1/ansilove-4.2.1.tar.gz"
  sha256 "60b1f1b6e4a5be287bb19310ea526c631a0bea5f4cb550f33c301a4b1ec30abf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa355a28549b83c25a3a8253d2310839916f36fdb297bb0b9501b8de0d976f74"
    sha256 cellar: :any,                 arm64_sequoia: "a2ebd555bc91908d5e5a19c2e7836b8156ae1ec73bd89937037682663878ba70"
    sha256 cellar: :any,                 arm64_sonoma:  "9c1dd009271113b0c90e6d4e945eb2f7e8e1f2ff1bbe76447e27c04741fc674f"
    sha256 cellar: :any,                 arm64_ventura: "fcd7297a08e54c44a7db0e19cce085c65f8fbceea158f40aab9900f816b600fb"
    sha256 cellar: :any,                 sonoma:        "0c4afe55030fe391aee91079e6a914a4bc989176d1e6cda14c571447de1ce8c4"
    sha256 cellar: :any,                 ventura:       "d33e47ed0c4b9956d65b8374db318b53926aed5296db5e56c9f4fa38fe253f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ae03d326bb2fa1250f8bf6d86a790d997ab6c5e9a05a211d9dc7583c3e9d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd6f63f8bfdd6b56e2ce0cb6cff1cbb54c0fb34c36e96d71d9104a5d2ef0ae3"
  end

  depends_on "cmake" => :build
  depends_on "libansilove"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_path_exists testpath/"output.png"
  end
end
