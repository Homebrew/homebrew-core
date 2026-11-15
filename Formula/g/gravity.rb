class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/0.9.9.tar.gz"
  sha256 "6b14bf45a0657c0e5a088e5dc941d72669b086847eb3474bcf65b37a522da548"
  license "MIT"
  head "https://github.com/marcobambini/gravity.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9e8301fce9e751f3123aa5f7a58a81d650ce05785727c98a2843452d3dce602"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9838676d3fe8c10e9149c6f90bfdb53fe9f162343a72bfb70170728126046bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "541343331427bf176eeb65f78a5068ba403e4b2a1964995af109a7dc2444040c"
    sha256 cellar: :any,                 arm64_linux:       "0eacb6001e90b237e1fae897399a9ca2c4e38bd778c456e2a0cc40de03219e4c"
    sha256 cellar: :any,                 x86_64_linux:      "25cacb4b7e2477d0d42dc6e70fc8c2b9a1c71ef3b3f8cb7e37c32cf818dd7cb0"
  end

  def install
    system "make"
    bin.install "gravity"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.gravity").write <<~GRAVITY
      func main() {
          System.print("Hello World!")
      }
    GRAVITY
    system bin/"gravity", "-c", "hello.gravity", "-o", "out.json"
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q -x out.json")
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q hello.gravity")
  end
end
