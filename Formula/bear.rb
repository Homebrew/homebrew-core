class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.4.tar.gz"
  sha256 "5e95c9fe24714bcb98b858f0f0437aff76ad96b1d998940c0684c3a9d3920e82"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "afa96da76034b3e1a89da1238efa1078f0a4d0ee508a7b2928a1917848223c29" => :catalina
    sha256 "5371f81233e1805fede6e16414e14b51e2b95d86751be84b839838f860b66a9c" => :mojave
    sha256 "34bef61a47160710ac0ff55896dd34f21476c86b01f18304337264f9dba3d798" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]
    system "cmake", ".", *args
    system "make", "install"

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
