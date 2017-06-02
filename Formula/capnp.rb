class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.6.0.tar.gz"
  sha256 "e50911191afc44d6ab03b8e0452cf8c00fd0edfcd34b39f169cea6a53b0bf73e"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe035ee20666f60bea72a033625e30981da7cf49bca28e3ded78daeb9a0cc9f3" => :sierra
    sha256 "5ef99277556769e117350e4c4c625c4498aab44aec043c24a3e8596ee98a311a" => :el_capitan
    sha256 "7068ca3b3c0db13d8669d1c6e70c5a4a5f31872b70741c8cd54485b5f66052db" => :yosemite
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
