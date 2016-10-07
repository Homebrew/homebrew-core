class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.4.0.tar.gz"
  sha256 "6393745fe8250ad0387b1fe3f4a2218cf692528acb55a4e0198ba5fbe1c81231"

  depends_on "cmake" => :build
  depends_on "node" => :build
  depends_on "boost"
  depends_on "cmake"
  depends_on "libzip"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "lua51"
  depends_on "luabind"
  depends_on "tbb"
  depends_on "ccache"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system "npm install"
    system "npm test"
  end
end
