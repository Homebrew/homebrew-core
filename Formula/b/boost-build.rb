class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.86.0.tar.gz"
  sha256 "243bc074d6ac3b55f91d6c16075ba73a1fd15918b2ccc5431c9be3c46ae06f21"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c752393f893651d507c3e0b2e985e7fa34948803de029c48318486189b1585db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c63aaf2e3aa3647a9acbd6a250898f6456d05715d9cf2b20bf23afca7a4ed1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b6cce6062de22313da350f857d57d64c69be7a22775e7561c6f4733ff40822f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97fa77800303262285787363d0750b5cf54747ddcaa9c53af35396f761269b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2befdb3a60a8a6416949dfb3d28a6365a37f273f0068afda7d59358e7cf71984"
    sha256 cellar: :any_skip_relocation, ventura:        "50889a2ecfb1e640079f5022dd3906a0049efadbb6686eb60dd6252ba941d2b4"
    sha256 cellar: :any_skip_relocation, monterey:       "52707a75c13a6a59c767a28504a92ca3cbf63dbdf5ee741bb5a520ea42045c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c3f6c3a82eb63af4c594b6caae876b87de2a36a57815c1102adc28bd8555f03"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    EOS
    (testpath/"Jamroot.jam").write("exe hello : hello.cpp ;")

    system bin/"b2", "release"

    compiler = File.basename(ENV.cc)
    out = Dir["bin/#{compiler}*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
