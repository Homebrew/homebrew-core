class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    mkdir "build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", ".."
      system "make"
      bin.install "bin/ps-eval"
      bin.install_symlink "ps-eval" => "pokerstove-eval"
      bin.install_symlink "ps-eval" => "pokerstove"
      bin.install "bin/ps-lut"
      bin.install "bin/ps-colex"
      bin.install "bin/penum_tests"
      bin.install "bin/peval_tests"
      bin.install "bin/util_tests"
    end
  end

  def caveats; <<~EOS
    `ps-eval` has `pokerstove` and `pokerstove-eval` as aliases.
    To run:
          pokerstove acas
          pokerstove AcAs Kh4d --board 5c8s9h
          pokerstove --game l 7c5c4c3c2c
      for more info, visit https://github.com/andrewprock/pokerstove
  EOS
  end

  test do
    system bin/"peval_tests"
  end
end
