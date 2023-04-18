class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.10.4.tar.gz"
  sha256 "981e7ef6dbe3ac745907e55a78870fbb491c5d23abd4ebc04e20ec235af4458c"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "51adfa510147834f2696bc918cff9ac9f5a7c0193c9e1592af30856ad30120e1"
    sha256 arm64_monterey: "1f60801ad206ee7b501f40e4484794ab8f113443ed6adced9871843b1e0ebe79"
    sha256 arm64_big_sur:  "b632dffa3fb1ba8d08b38d39457aff354cb54a00c865b6e9178c363aa302ee86"
    sha256 ventura:        "a46864826a212ee9e9d4c02c7a9f76f3e61ade801401cdb02077dfbd52a32fbd"
    sha256 monterey:       "4f8feb4f1e22147fddacba8c9553fe099d3648e5ad84e5b4f1a3428670577ba5"
    sha256 big_sur:        "da152c080d1f7051f432dae591e2566ab889c01203a8b37de28e0af88a76ee73"
    sha256 x86_64_linux:   "7f10aed00c8fc2105399e567f883f07a51ad633cf3de4861ce2e7df9828c16da"
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
