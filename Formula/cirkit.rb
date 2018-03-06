class Cirkit < Formula
  desc "Logic synthesis toolkit"
  homepage "https://msoeken.github.io/cirkit.html"
  url "https://github.com/msoeken/cirkit", :using => :git, :branch => :develop, :revision => "9a097c9a23d050b2c84a7c1c6a874859a6475ba6"
  version "2.4b15"

  head "https://github.com/msoeken/cirkit", :using => :git, :branch => :develop

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "readline"

  depends_on "python" => :optional

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"

      Language::Python.each_python(build) do |_, version|
        system "cmake", "..", "-Dcirkit_ENABLE_PYTHON_API=ON", "-DCMAKE_PYTHON_SITE_PATH=#{lib}/python#{version}/site-packages", "-DPYBIND11_PYTHON_VERSION=#{version}"
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/cirkit", "-c", "help; quit"
  end
end
