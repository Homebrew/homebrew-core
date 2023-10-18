class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.7.tar.gz"
  sha256 "80a12675094a0cac90e70ee530e936dc76ca0953cb0443f7283c2b558635e4fe"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "aa74cb1dcfdc0f882acbca3f671ccbcc805ddfa76ef1d579a7cb3a6dbb441724"
    sha256 arm64_ventura:  "9a8da24b7dd2febef42257df7e2f072d8ff759e9da1fca7d4ef38767707ccced"
    sha256 arm64_monterey: "c9b669e17ba4df32320297a8cee6d7738b03d2a3e1d69e5c22e755e671bcd0d4"
    sha256 sonoma:         "a40362d0f783eeafe97e718956236c7de236ed12fdc0b9f0e8de09dd3f0e7931"
    sha256 ventura:        "41dca10c1d8cf7bcb829364a9b3d9f03e0bb2557e15f67a6363ce2d795ff9059"
    sha256 monterey:       "e7e58e4c8a225084a112537ffcc7ecdb08052d13946dea3023c2fa2431f44869"
    sha256 x86_64_linux:   "ced3e475ceac81b5af845ce43e15fc085afca1db3b74cfdff68628d015a4e808"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    ENV.cxx11
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output("#{bin}/opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
