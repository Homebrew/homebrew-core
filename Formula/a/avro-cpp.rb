class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https://github.com/Homebrew/homebrew-core/pull/146296#issuecomment-1737945877
  # https://apple.stackexchange.com/questions/197839/why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https://github.com/apache/avro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de6b8abaa622b8d35a2ff8be108fb1fa5a1e6833f6013bfc99c6fda3dbc1433f"
    sha256 cellar: :any,                 arm64_ventura:  "ebbde47ae62e4e67f27aedba49cf6405d76ea9e61f99d2e3054a773e8c267e61"
    sha256 cellar: :any,                 arm64_monterey: "fbc6ea273a0e3877402e3fdd85337545c07bee6c6f64b84e9fcca1da0636faea"
    sha256 cellar: :any,                 sonoma:         "445b5d16fad32920c7722a0c41160409f4ec186b72236f1c629b9363ae0b75f6"
    sha256 cellar: :any,                 ventura:        "fc870ae92554f3d217650ca25b3ab4fe9444d651087fc8d523322dc65aa8e5c7"
    sha256 cellar: :any,                 monterey:       "4826cdc0275cfc340d42089b1358eff5913549dfafa007a4c12894342ba4bbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7b15e8afb93277b12fd19a2ae3004c4f25621f0489e6e28fbf46d67db70b21"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    cd "lang/c++" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
