class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://www.gravity-lang.org/"
  url "https://github.com/marcobambini/gravity/archive/refs/tags/0.9.8.tar.gz"
  sha256 "c221a8dc747e46de61482631209efd1c3cd95c1b8dd441e7eeeefcdb2fbfce5a"
  license "MIT"
  head "https://github.com/marcobambini/gravity.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b614f8dbfa6431e31a5d319074600edb9b7b2b7ecf4091206ca3f13db26c2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d97ebd241f51fd20069ae0d1de6a80a333853c358dd81321eef7c5a20490d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e247a20d7b3ff45c439260d96ed1cdda1ef5aaee838515ffddf99613ae09a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c5ca24b9c6de57d9ed7f236de8dd332b82a460ff95bf59e188b2f509fa9a38"
    sha256 cellar: :any,                 arm64_linux:   "a11deed37024839e5844abe6b1dc3cff723eaad826c6f0efa1b5d6e4aea725c2"
    sha256 cellar: :any,                 x86_64_linux:  "e75a4c3ff3d58a4aec68e194d9af29ca0d1a604c8d002e26fb980486616351cf"
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
