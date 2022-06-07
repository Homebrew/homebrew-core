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
    sha256 arm64_monterey: "f29efbb4780d6a29e9e8d917700cc710c2233c7362b358a798e64439f80d942f"
    sha256 arm64_big_sur:  "d6430862db731ac62235e0a4637f485175486e7af1c90b532b8ebd6355e08690"
    sha256 monterey:       "2d10f5bff0137eeec97dc6df6cf107fa10b5bf246c0cd81b2444b17bb9310c16"
    sha256 big_sur:        "77a0120ece805fb4f451bfcb039013418a011455581aebff0db9bd627bdaed7b"
    sha256 catalina:       "b5f725e92ed4c8d130ab19e0f0d0da1281a1c5acb3e518ad1e0ee10a94b8dd45"
    sha256 x86_64_linux:   "0f55802e4bb1cc7b43d8b2a5e7e8c9a35bebcddeb8a230b85cc7c1ec98bb616d"
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
