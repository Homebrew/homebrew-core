class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.0.tar.gz"
  sha256 "5f38139939cbc8cbd0f2b4d063d5075977bb53e51b8f956acc2b27bded8f686d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "4151eef4687fffd39dffb9c47d51bf65eb0ecbbad80eae03af2dec94b67abb14" => :sierra
    sha256 "a8ffe9463c298cef18f3bc3b1ee327e70fb28f91dede695e6b9022b105d41310" => :el_capitan
    sha256 "65a19f3c9abcdf286a27d4e60b56f6376a0f4eba0292dc2faf81bdd749c7b4dc" => :yosemite
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
