class Protozero < Formula
  desc "Minimalistic protocol buffer decoder and encoder in C++"
  homepage "https://github.com/mapbox/protozero"
  url "https://github.com/mapbox/protozero/archive/v1.3.0.tar.gz"
  sha256 "85f9238fa662ff06a1e364f1461846a9d377846274e7f98407307e31086cab2b"

  def install
    (include/"protozero").install Dir["include/protozero/*"]
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <protozero/pbf_reader.hpp>
      int main() {
        const char raw[] = { 0x12, 0x06 };
        std::string check = "foobar";
        std::string input(raw, 2);
        input += check;
        protozero::pbf_reader message(input);
        while (message.next()) {
          switch(message.tag()) {
            case 2:
            {
              std::string s = message.get_string();
              if (s == check) {
                return 0;
              }
              break;
            }
            default:
              message.skip();
          }
        }
        return 1;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-std=c++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
