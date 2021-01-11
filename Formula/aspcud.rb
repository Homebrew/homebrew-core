class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/v1.9.5.tar.gz"
  sha256 "9cd3a9490d377163d87b16fa1a10cc7254bc2dbb9f60e846961ac8233f3835cf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 "5696aa5e1520bbdb4d6c279944325ab6b2bc0e0b109e648037bbec0aad880938" => :big_sur
    sha256 "3271ff048eea3fb3bbf5b22b8f59bce767362cf2b5e15935be0b407fba8914fd" => :catalina
    sha256 "3363c5cfa7f9ad4dd35ddb172c5eb878a504000bae59a477e5ea9246fe27680a" => :mojave
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "clingo"

  def install
    args = std_cmake_args
    args << "-DASPCUD_GRINGO_PATH=#{Formula["clingo"].opt_bin}/gringo"
    args << "-DASPCUD_CLASP_PATH=#{Formula["clingo"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"in.cudf").write <<~EOS
      package: foo
      version: 1

      request: foo >= 1
    EOS
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
