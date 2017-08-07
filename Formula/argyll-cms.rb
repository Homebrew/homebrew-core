class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V1.9.2_src.zip"
  version "1.9.2"
  sha256 "4d61ae0b91686dea721d34df2e44eaf36c88da87086fd50ccc4e999a58e9ce90"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "b08303e9d386c46d2f910a3a6077653d04822eb2eff61c3d1dc900b8b85749f4" => :sierra
    sha256 "b1e1913b39b6055ceb4c34b3c2d85495d9ae4ea7ab20e7f0d1653ffbe504a23d" => :el_capitan
    sha256 "631f27bf6c5da161141f6d9113cd59765f8985f39f19950b10e5e144bdc5ad00" => :yosemite
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  def install
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each { |f| File.exist? f }
  end
end
