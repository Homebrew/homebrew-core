class Latino < Formula
  desc "Lenguaje de programación de código abierto para latinos y de habla hispana"
  homepage "https://www.lenguajelatino.org/"
  url "https://github.com/lenguaje-latino/latino.git",
      tag:      "v1.4.1",
      revision: "3ec6ab29902acb0b353cfe9a7b5d0317785fbd88"
  license "MIT"
  head "https://github.com/lenguaje-latino/latino.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aac984134bbd599ee76ccd80ae017c738f633a4642a7a99ce8c40ead45078d8b"
    sha256 cellar: :any,                 arm64_monterey: "96c4a79b87f5f1c44ee9a39d13e75ced35a8b23ed5ee209279690363e79cb876"
    sha256 cellar: :any,                 arm64_big_sur:  "e7ac6aa7973d222c73097942a233c2998e542358b21aa725dcbbf8e1e6010b06"
    sha256 cellar: :any,                 ventura:        "0b965dcb6c5701e3519aaeb04e676b53e3962763b5eb9a437548ff8b5d06c839"
    sha256 cellar: :any,                 monterey:       "952cc3322325e09ceb9fcbb00c957a4179031f7522c99ae6afbc20bb13bc3d13"
    sha256 cellar: :any,                 big_sur:        "0848f83a97ae97c615e2a448eb28573fce7c20f20b3b52ddb6d9f487c80524ac"
    sha256 cellar: :any,                 catalina:       "46af81ff7b1693cd40465ce5e0defb7a708c918a996db2af775b913cc682a567"
    sha256 cellar: :any,                 mojave:         "2a3e48e1a672715eadfc5401ec7683ee91f7acff18ad8e7e600be3f8c09fee06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "134dda0b3f3b59b4725c7d9cb692b2e57f2c56355dba24e8e9908d03f56bb2b0"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "readline"
  end

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
