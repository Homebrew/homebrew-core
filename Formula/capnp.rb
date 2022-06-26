class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.10.1.tar.gz"
  sha256 "91413335e2f078017c22e0b1be91c28af9dd7dd8127b88914d21c2bcea55df51"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cf4352d304acbc3efc850209f34cec32ec70472edbe139ac83caebbbc90d94ba"
    sha256 arm64_big_sur:  "772932eac02c7c407d574d2cc8e1ead9f68225b0094137e2d63c3c1caf195fe4"
    sha256 monterey:       "5d87dc87b14828f2afbac22a055b3cdb7b08d3c7bd4275b925df04e8c6a025c2"
    sha256 big_sur:        "4be05582ce7938b7aab9082cb3f7a3c75fc6b1a527fc1d83fbd9627c54dbe422"
    sha256 catalina:       "c8b13089224a39ce6b8632861fc52f333be2d634854decdf23e5907efe0fe77b"
    sha256 x86_64_linux:   "484bf4c433b99c0ddb1cf7aae38844e4dc112469d266236c158b3de40e6d7c65"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write shell_output("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
