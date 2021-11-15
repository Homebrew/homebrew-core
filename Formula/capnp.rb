class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.9.1.tar.gz"
  sha256 "83680aaef8c192b884e38eab418b8482d321af6ae7ab7befa3a9370b8e716aad"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b2859736c7a3979fa5a11535ef2ddb55d5613020e48160f3825d7bf58c82c5f4"
    sha256 arm64_big_sur:  "8043e17871dd912ba43bea535529002ad50cf6cb4915b97e09be64e37549630f"
    sha256 monterey:       "524e7613b378c1562df99ec4129fb253cf6d6bcc5b0904167faa89a6473d5924"
    sha256 big_sur:        "bba67dd6a19595bcf2ca687bcce24a725fb05ee3e862506ddc6cbb7aec87defd"
    sha256 catalina:       "587630a09f37214d09864150ba694cc089b326cc57fe787427a71114b4b26244"
    sha256 mojave:         "b0d06dffe22d722e87a066b80cf667cb41372f175a80cd6877b5d856bfb080ac"
    sha256 x86_64_linux:   "23877c82c6b6661adbdd98aad98ccb9b42e23210ad0001b27ea81983acc0db77"
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
