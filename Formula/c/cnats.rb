class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "45072849d16db3ef57abe52496029fcd43b0758e8f8a980cc00a55da97b8402a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "75554486601074b593b37f5f48a9d92930c7eec4171d9148b2ffca4e9a895d29"
    sha256 cellar: :any,                 arm64_sonoma:  "0ab32de7fa305f0a46fe64ef73e102e92e1b937715c59b5b4204c4690cf2da94"
    sha256 cellar: :any,                 arm64_ventura: "79ae44bfa37c4b01e9a605871a3a9c37f73bc4ba5ca4cf5791ace636d835b12c"
    sha256 cellar: :any,                 sonoma:        "dfb4c803c55e6dab4dac9905c47bdffa5a65e2b980f556e24082a731db91df0a"
    sha256 cellar: :any,                 ventura:       "f64d11c028d84d82d3490e7e0914508d833b172b470ca0fff4ea881fecaf532a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83878663d4c3b38c63da559e3b7e89bd77fa8fb3702392cbf7bf6ff0e8a994b5"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
