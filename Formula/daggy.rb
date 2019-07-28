class Daggy < Formula
  desc "Data Aggregation Utility for aggregation data from your network"
  homepage "https://daggy.dev"
  url "https://github.com/synacker/daggy/archive/1.1.3/daggy-1.1.3.tar.gz"
  sha256 "559a9d7916988edf67be50625d89b38c311edaa322c3238e0107883dc315f0c6"

  depends_on "botan"
  depends_on "qt"
  depends_on "yaml-cpp"

  def install
    system "#{Formula["qt"].bin}/qmake", "PREFIX=#{prefix}", "CONFIG+=release", "VERSION=1.1.3", "BUILD_NUMBER=0"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "daggy", shell_output("#{bin}/daggy -v")
  end
end
