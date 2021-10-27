class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-69-1/icu4c-69_1-src.tgz"
  version "69.1"
  sha256 "4cba7b7acd1d3c42c44bb0c14be6637098c7faf2b330ce876bc5f3b915d09745"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3771949f179992723acc5bf1457bb5bab960e1f6887913b9e7378023dba6394c"
    sha256 cellar: :any,                 arm64_big_sur:  "25a1ec460d422ba5abff15dc5cb60ad36003ad021585fa7be278d1dca6fcd2c4"
    sha256 cellar: :any,                 monterey:       "3cf5e9b63ae618b577e057b5745e3ceff557e546d5520c749d3ecd8184750fb5"
    sha256 cellar: :any,                 big_sur:        "d46b8ec5c3db629e7848e9fd31e5ec99ed952d9c81c8936a2511fae803d831fd"
    sha256 cellar: :any,                 catalina:       "3f75c907dadc6e7e647920506e740a312e56279369f3c9708cac54b018410120"
    sha256 cellar: :any,                 mojave:         "e0362362d26379b8c2456de163a148bc4e186d058ea8ed4a38fe41354bea96a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "781fa2a4d1e2eed1fbea456d8f39770668ef78f922bbab26adeae30c1f5ae760"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system "#{bin}/gendict", "--uchars", "hello", "dict"
    end
  end
end
