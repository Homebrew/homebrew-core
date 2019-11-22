class Precomp < Formula
  desc "Command-line precompressor to achieve better compression"
  homepage "http://schnaader.info/precomp.php"
  url "https://github.com/schnaader/precomp-cpp/archive/v0.4.7.tar.gz"
  sha256 "b4064f9a18b9885e574c274f93d73d8a4e7f2bbd9e959beaa773f2e61292fb2b"
  head "https://github.com/schnaader/precomp-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ac9f156315ae463a1e378bdd9ed06d5f36437ccff4505740dfa10ee914b5adf" => :catalina
    sha256 "7488435759867b2bb152cdd3ea78d2358659b34ff838e2cb97b54bd3a322147b" => :mojave
    sha256 "92824cc03c547d276436e1bdf55e905d402f77eeccf61f25a720d4315e5bd4cf" => :high_sierra
    sha256 "5d852d83cf57987a521471b74e450a65473ed20e32bb14e83b5d99e969e37458" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "precomp"
  end

  test do
    cp "#{bin}/precomp", testpath/"precomp"
    system "gzip", "-1", testpath/"precomp"

    system "#{bin}/precomp", testpath/"precomp.gz"
    rm testpath/"precomp.gz", :force => true
    system "#{bin}/precomp", "-r", testpath/"precomp.pcf"
    system "gzip", "-d", testpath/"precomp.gz"
  end
end
