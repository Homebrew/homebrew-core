class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.6.tar.gz"
  sha256 "169bff4071ffe814dc16df7d180ff6610db418f4816e9c0ce02cf874bdf058df"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "d660b5ca78b6aa2f473ad57e7acbff2422d804dd40573bd6a3f6c8200b5f762f"
    sha256 arm64_monterey: "743f33ed76117d13c67b117f62885918a9ef46de9081dff39522adec5b08a28e"
    sha256 arm64_big_sur:  "952232eff49bc366c65b5b2cc1d690b5f8bf10d263ebeffea85d8ed6fa2de840"
    sha256 ventura:        "111fcb1f13bd06b8c27c0ca07fb98f1094944fa39930880b5f224ac66b5712eb"
    sha256 monterey:       "151e193c88cdf4ae672afb4618bff3d40bf6ba9e6887255bb9462f188b227a0c"
    sha256 big_sur:        "d1e53be3298e34e69df9b3c894149ac8757acd2790f9cb4310ca29216ea43e1f"
    sha256 x86_64_linux:   "ba78435ec20af1fb82877f6158bc1a7f6e117371280e06b02e1f76f61cadeadd"
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
