class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.84.0.tar.gz"
  sha256 "1f252e3af95279ec569927a9a582db98f107635aefee773e03836d17c4e57b86"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7eb694320592be81ac7284131c921d15104ad2797a7f0353f3275a0b0b28dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e042c46b530f4667b30b71230a996c111091715a87b69df09419331b3bfebd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71d77442d4b38e0cf0d9aa3c88faea910044c7409ad33a9b592cc8c1110b3347"
    sha256 cellar: :any_skip_relocation, sonoma:         "c898365562decc2aa29232c60551fb837b50631ea1221281bf20c532b531bb54"
    sha256 cellar: :any_skip_relocation, ventura:        "fa46d649b818cad15d4b40485d11c592d6ea68da48fd6e3f6371ff14d6bf4c86"
    sha256 cellar: :any_skip_relocation, monterey:       "0a5cdcf3f2bfa4c3305fe648d99f00f599d62afb122ae2693bad4acedbb568e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30b1767f9faac82ee597746bf87aaad037f3428dbd939988f4f622195c79218"
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
