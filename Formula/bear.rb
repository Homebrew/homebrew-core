class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.3.tar.gz"
  sha256 "74057678642080d193a9f65a804612e1d5b87da5a1f82ee487bbc44eb34993f2"
  revision 1
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "9eb44bc5187c1986a1e1650315df5e1632af4ea0333a39fa8c8a2a320c87b072" => :catalina
    sha256 "07a6d7a49a420177a0b4abeffc91bdb578527a2c6e16e7807ef35dbb1cd8cc69" => :mojave
    sha256 "d7c87944b1c2ada8378c85b7123f026524166bc8629332beb294c1ce83fc180a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  def install
    args = std_cmake_args + %W[
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
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
