class Latino < Formula
  desc "Lenguaje de programación de código abierto para latinos y de habla hispana"
  homepage "https://www.lenguajelatino.org/"
  url "https://github.com/lenguaje-latino/latino.git",
      tag:      "v1.4.1",
      revision: "3ec6ab29902acb0b353cfe9a7b5d0317785fbd88"
  license "MIT"
  head "https://github.com/lenguaje-latino/latino.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e7ac6aa7973d222c73097942a233c2998e542358b21aa725dcbbf8e1e6010b06"
    sha256 cellar: :any, big_sur:       "0848f83a97ae97c615e2a448eb28573fce7c20f20b3b52ddb6d9f487c80524ac"
    sha256 cellar: :any, catalina:      "46af81ff7b1693cd40465ce5e0defb7a708c918a996db2af775b913cc682a567"
    sha256 cellar: :any, mojave:        "2a3e48e1a672715eadfc5401ec7683ee91f7acff18ad8e7e600be3f8c09fee06"
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
