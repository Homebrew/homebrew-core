class Latino < Formula
  desc "Open source programming language for Latinos and Hispanic speakers"
  homepage "https://www.lenguajelatino.org/"
  url "https://github.com/lenguaje-latino/latino.git",
      tag:      "v1.4.4",
      revision: "4d8ed2e690dd1efcc47a9f8f790b8a9aeba4b808"
  license "MIT"
  head "https://github.com/lenguaje-latino/latino.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cf212c61bd3713e4a553669d53d6e8f151e2c7e4e87bc438a49d112219c8426"
    sha256 cellar: :any,                 arm64_sequoia: "844abdcfdef8d27337343bf5545836b23adf30738de6b146a35090f23de90c90"
    sha256 cellar: :any,                 arm64_sonoma:  "3f71439866df37de2cbe8fb5c711b770d70186e57a2e3a586dfddd95264aa3df"
    sha256 cellar: :any,                 arm64_ventura: "dbe2fc1ead1951d6c44a9b96638e3ae889322eb7ebb634a826618bed50b16e06"
    sha256 cellar: :any,                 sonoma:        "63944aac895d9ec94344a647f9adeab4f4fb9a8d2bb548999d39aa7eb874af0b"
    sha256 cellar: :any,                 ventura:       "5a940fde4f7577543fefc1c54ddd0b56b9b09078b9b77acc70b957b8cbc14631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76af2f42cfac533a45afa82f95b24ee0b58a233ad7d96396d3c170f300fcdcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8732dbdcbb9723660ff9261f790d3f48f929a6e4d95842471d2a3076fe6618c9"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
