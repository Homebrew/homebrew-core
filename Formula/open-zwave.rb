class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "https://github.com/OpenZWave/open-zwave/archive/v1.6.tar.gz"
  sha256 "3b11dffa7608359c8c848451863e0287e17f5f101aeee7c2e89b7dc16f87050b"

  bottle do
    sha256 "cf06f87e2f334038f09897ed3bc91aba37e037bd3a2a8850b81ec58d4b3bad45" => :mojave
    sha256 "ee97a2cce9fed3f63fb917e09e448f35815eff5120ebae16711777be4796d5c0" => :high_sierra
    sha256 "68502b64e9fb7031f9fc5fe4fa7e6714fd5e5ab93d467169e7e47e90c322ff64" => :sierra
    sha256 "4bf1d8a8ba3fcf4ee39df9bfe09017d3a432047e5e6bf0dce6f6e612ad174b95" => :el_capitan
    sha256 "9ceb267d8fb564daefb535f65ac71f426535f7552b9feffcb3638793f0c40810" => :yosemite
    sha256 "753eb6cb76dd0c170c1e84285a702fb9fb49c76aa8d59970ecea2160938f0bba" => :mavericks
  end

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    # The following is needed to bypass an issue that will not be fixed upstream
    ENV["pkgconfigdir"] = "#{lib}/pkgconfig"

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <openzwave/Manager.h>
      int main()
      {
        return OpenZWave::Manager::getVersionAsString().empty();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/openzwave",
                    "-L#{lib}", "-lopenzwave", "-o", "test"
    system "./test"
  end
end
