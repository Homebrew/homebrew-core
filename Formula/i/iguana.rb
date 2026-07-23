class Iguana < Formula
  desc "Universal serialization engine"
  homepage "https://github.com/qicosmos/iguana"
  url "https://github.com/qicosmos/iguana/archive/refs/tags/1.2.0.tar.gz"
  sha256 "29ad1ff853a278df0b1598db992e1507167bd4521b232a55e360928cf751a9af"
  license "Apache-2.0"
  head "https://github.com/qicosmos/iguana.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "647bd296c4d028e746df79db3049226d6c0bf72cdb0e9869bc0f7d7275d5788e"
  end

  depends_on "frozen"

  def install
    include.install "iguana"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iguana/json_writer.hpp>
      #include <string>
      #include <iostream>
      struct person
      {
        std::string  name;
        int          age;
      };
      auto main() -> int {
        person p = { "tom", 28 };
        std::string ss;
        iguana::to_json(p, ss);
        std::cout << ss << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-L#{lib}", "-o", "test"
    assert_equal "{\"name\":\"tom\",\"age\":28}", shell_output("./test").chomp
  end
end
