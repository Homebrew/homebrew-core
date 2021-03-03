class Latino < Formula
  desc "Lenguaje de programación de código abierto para latinos y de habla hispana"
  homepage "https://www.lenguajelatino.org/"
  url "https://github.com/MelvinG24/Latino/archive/v1.3.0.tar.gz"
  sha256 "28118a047265394ad9a5fcb2c76895d08af4b43a5886f52afce98a0f8cdc86fe"
  license "MIT"
  head "https://github.com/MelvinG24/Latino"

  depends_on "cmake" => :build

  def install
    mv "logo/Latino-logo.png", "logo/desktop.png"
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test1.lat").write "poner('hola mundo')"
    (testpath/"test2.lat").write <<~EOS
      i=0
      repetir
        poner(i)
        i++
      hasta(i>=10)
    EOS
    output = shell_output("#{bin}/latino test1.lat")
    assert_equal "hola mundo", output.chomp
    output2 = shell_output("#{bin}/latino test2.lat")
    assert_equal "0\n1\n2\n3\n4\n5\n6\n7\n8\n9", output2.chomp
  end
end
