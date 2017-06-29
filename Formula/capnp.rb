class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.6.1.tar.gz"
  sha256 "8082040cd8c3b93c0e4fc72f2799990c72fdcf21c2b5ecdae6611482a14f1a04"

  bottle do
    cellar :any_skip_relocation
    sha256 "02d729a3d9c6267ff0bea777ade442da70410f04f4f478e789d6f02ca4ad8069" => :sierra
    sha256 "2393cf083cccf35613b7bd293d87a52f201a4f0cd48bce8d0cd60300808ee203" => :el_capitan
    sha256 "726278b97a0fab5be359b604b08dc8ea9b5cd7a8a1e350e6724aaa40b7bbd5a2" => :yosemite
  end

  needs :cxx11
  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write Utils.popen_read("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
