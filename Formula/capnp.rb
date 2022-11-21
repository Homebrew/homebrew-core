class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.10.2.tar.gz"
  sha256 "7cd91a244cb330cda5b41f4904f94b61f39ba112835b31fa8c3764cedbed819f"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "db8932b34a53c64dd431165ef9e5683c46c2f698d7be3bc221d89399368e7081"
    sha256 arm64_monterey: "de8d7702cb12c4d4d8b2a8a2db7d263d40e3ada7757232d52f0b942c3c5cdf8f"
    sha256 arm64_big_sur:  "a7b07b5c74cbea12627b7a1842eaa026c974cb635a05c8d999e986373dce1598"
    sha256 ventura:        "68156f3f54abced800ef34b9c54d87eb1ab9a8a063e1acc57463e3c3c48df4db"
    sha256 monterey:       "2035bf735e2f643a3f8e0826fb1d370256e10c8ed45c3cce1b861c3c09386d8f"
    sha256 big_sur:        "9186cf7161f52e446240b9bf3e5fe5cdd8ca4461490fe31b9c0c23038a5d21d7"
    sha256 catalina:       "0c594af504f9469aa957f0312328163a31b8dba474dea1c49530dacfff91c3d3"
    sha256 x86_64_linux:   "86739257a224ddf90db79ce97f82aa56cfc0f06214f052c66e893bbb5d8d12d6"
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
