class Latino < Formula
  desc "Lenguaje de programación de código abierto para latinos y de habla hispana"
  homepage "https://www.lenguajelatino.org/"
  url "https://github.com/lenguaje-latino/latino.git",
      tag:      "v1.4.1",
      revision: "3ec6ab29902acb0b353cfe9a7b5d0317785fbd88"
  license "MIT"
  head "https://github.com/lenguaje-latino/latino.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dab07196acce245e9876fac1be97127e65d0111ffdbf7e08695cb7468c12b060"
    sha256 cellar: :any, big_sur:       "3f1d3892f16fd82ce53434d6f0b3d7e27a799e390450f2cc5bb851a47b88aa92"
    sha256 cellar: :any, catalina:      "cb134d3aef396a2d84acfb1807a2d9735c3252baeab1313dc4d3654823253168"
    sha256 cellar: :any, mojave:        "73c7c6ce9b5ff470368fb1bb0e54be92aa376577c396428535b79bf1f76aefc1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test1.lat").write "poner('hola mundo')"
    (testpath/"test2.lat").write <<~EOS
      desde (i = 0; i <= 10; i++)
        escribir(i)
      fin
    EOS
    output = shell_output("#{bin}/latino test1.lat")
    assert_equal "hola mundo", output.chomp
    output2 = shell_output("#{bin}/latino test2.lat")
    assert_equal "0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10", output2.chomp
  end
end
