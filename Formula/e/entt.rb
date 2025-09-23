class Entt < Formula
  desc "Fast and reliable entity-component system for C++"
  homepage "https://github.com/skypjack/entt/wiki"
  url "https://github.com/skypjack/entt/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "01466fcbf77618a79b62891510c0bbf25ac2804af5751c84982b413852234d66"
  license "MIT"
  head "https://github.com/skypjack/entt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86074bf1b1b86d90191ff16eadc4e04849293c273748e7e95f0e7298a2529425"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENTT_INSTALL=ON", "-DENTT_BUILD_DOCS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <entt/entt.hpp>

      struct Position { float x, y; };

      int main() {
        entt::registry registry;

        auto entity = registry.create();
        registry.emplace<Position>(entity, 1.0f, 2.0f);

        auto e2 = registry.create();
        registry.emplace<Position>(e2, -3.0f, 4.5f);

        auto view = registry.view<Position>();
        for (auto entity : view) {
          auto &pos = view.get<Position>(entity);
          std::cout << int(entity) << std::endl;
        }

        return 0;
      }
    CPP
    pkg_config_flags = shell_output("pkgconf --cflags --libs entt").chomp.split
    system ENV.cxx, "-std=c++17", *pkg_config_flags, "test.cpp", "-o", "test"
    system "./test"
  end
end
