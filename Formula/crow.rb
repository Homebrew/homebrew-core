class Crow < Formula
  desc "C++ microframework for web. (inspired by Python Flask)"
  homepage "https://github.com/ipkn/crow"
  url "https://github.com/ipkn/crow/archive/v0.1.tar.gz"
  sha256 "140ca4a4d75ce5996cb103155580cb13b0b27082d1efbc331000a34af55b4390"

  depends_on "boost"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <crow.h>
      int main()
      {
        crow::SimpleApp app;
        CROW_ROUTE(app, "/")([](const crow::request&, crow::response&)
        {
        });
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-lboost_system", "-o", "test"
    system "./test"
  end
end
