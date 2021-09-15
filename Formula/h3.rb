class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.7.2.tar.gz"
  sha256 "803a7fbbeb01f1f65cae9398bda9579a0529e7bafffc6e0e0a6d81a71b305629"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 big_sur:      "2f85bec4f86968b06974f875db8c92b6cd3514905d58833c703563e3e74315f8"
    sha256 cellar: :any,                 catalina:     "5658314536778f29b20326170d3d9a97d1fbf4b9fccca0cb8a7443a2f0588e01"
    sha256 cellar: :any,                 mojave:       "ba14e992f20afca2dcbbed18319c7c93a0d58b347c294dc6e9384bced47e9989"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64cd87bb7ea604ade45efa5198c7af2d89774bc4f2fe17239ff44ae611e6c22f"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    result = pipe_output("#{bin}/geoToH3 -r 10 --lat 40.689167 --lon -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
