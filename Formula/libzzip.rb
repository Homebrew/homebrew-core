class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.71.tar.gz"
  sha256 "2ee1e0fbbb78ec7cc46bde5b62857bc51f8d665dd265577cf93584344b8b9de2"

  bottle do
    cellar :any
    sha256 "e5d1924bd3078e0ec191022a1472b9fed24df6217bca8a96eaa3124baa63fee1" => :catalina
    sha256 "e6060c02eaeb6df911ae74896181c261c1b235891f4a470e2afe8aea3c4846e5" => :mojave
    sha256 "18edacbb19f463f1481eae261ec25f4c643c659703ff1d1d2ae59b28684a0fc3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DZZIPSDL=OFF"
      system "make", "man"
      system "make", "install"
    end
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
