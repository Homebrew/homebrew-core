class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "http://www.argyllcms.com/"
  url "http://www.argyllcms.com/Argyll_V1.9.0_src.zip"
  version "1.9.0"
  sha256 "93adb00665505a1859573c7f286d991c1c07cae2883b65d67a258892c731880e"

  bottle do
    cellar :any
    sha256 "d86ab3aa7071bbb416a9e4bbe715334f40679af066cb31a2cc755dcc5d0f28e8" => :sierra
    sha256 "8dcc7b2562aaf1d02d5f31b1e486b6fe2bdcb58e740825a2b35d7b2766ea0c74" => :el_capitan
    sha256 "4b72e471ff70cb96c356d6ae111cae9ae8d3e3117f6beb851911c4703e4b94b3" => :yosemite
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
