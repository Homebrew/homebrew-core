class Nvi2 < Formula
  desc "Multibyte fork of the nvi editor for BSD"
  homepage "https://github.com/lichray/nvi2"
  url "https://github.com/lichray/nvi2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a1ad5d7c880913992a116cba56e28ee8e7d1f59a7f10e5a9b2ce6d105decb59c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04389c7abf1b4ea96dbcaaebf60ec662d96a4673c8a2a177a733ee4304577845"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b857d74bb76858bb49560e80f070049dcf93b90ee04e1bbbd2b20859b2b11e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2fd58a30a46cb71ca8938882793a1b569a5ce75ea582798ec91cd19d1f08d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "75165cb105f32ca879af45654cc77965f4eb85084a0acaf39dcf9ee9fa0b87bc"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    man1.install "man/vi.1" => "nvi.1"
    bin.install "build/nvi"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/nvi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
