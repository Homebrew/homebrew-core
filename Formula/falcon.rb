class Falcon < Formula
  desc "Multi-paradigm programming language and scripting engine"
  homepage "http://www.falconpl.org/"
  url "https://mirrorservice.org/sites/distfiles.macports.org/falcon/Falcon-0.9.6.8.tgz"
  mirror "https://src.fedoraproject.org/repo/pkgs/Falcon/Falcon-0.9.6.8.tgz/8435f6f2fe95097ac2fbe000da97c242/Falcon-0.9.6.8.tgz"
  sha256 "f4b00983e7f91a806675d906afd2d51dcee048f12ad3af4b1dadd92059fa44b9"
  revision 1

  bottle do
    cellar :any
    sha256 "fab1a5546fe1e1abff7525ef791126c341fc305ef1bee37ad3b1c2788342c451" => :big_sur
    sha256 "8727eb2b82dfbe15b089ffe42ff0e5f205399badde1c7dcfaf470a13141e4334" => :arm64_big_sur
    sha256 "0fdfed49f1ba12e66db6a7d9f315677280600f6db52afd52c91e6e66235c3053" => :catalina
    sha256 "d87b0664e797106f23bd5167c32988a7154d177955c2f612803999ebc4306fd9" => :mojave
    sha256 "670ae92a7f950558ea95001b45a848ef6d3f98d5fa414ba3549032d07badca47" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "mysql@5.7" => :build
  depends_on "pcre" => :build

  def install
    args = std_cmake_args + %W[
      -DFALCON_BIN_DIR=#{bin}
      -DFALCON_LIB_DIR=#{lib}
      -DFALCON_MAN_DIR=#{man1}
      -DFALCON_WITH_EDITLINE=OFF
      -DFALCON_WITH_INTERNAL_PCRE=OFF
      -DFALCON_BUILD_FEATHERS=OFF
      -DFALCON_BUILD_SDL=OFF
    ]

    system "cmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      looper = .[brigade
         .[{ val, text => oob( [val+1, "Changed"] ) }
           { val, text => val < 10 ? oob(1): "Homebrew" }]]
      final = looper( 1, "Original" )
      > "Final value is: ", final
    EOS

    assert_match(/Final value is: Homebrew/,
                 shell_output("#{bin}/falcon test").chomp)
  end
end
