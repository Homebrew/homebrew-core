class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.0.tar.gz"
  sha256 "86736893617433e84c1adc1a664ef94ebca53eec77028c3bb5c8b1a10d8a4d1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf9d1e7298cea967c086690fee53d7f806de4ff2fdc919fbb0fa74ad1deb8831" => :catalina
    sha256 "b9b02e1b3f36f4e4fc296d71cd2fa6c07f97593779a9127af74c6e09e9efaf5d" => :mojave
    sha256 "304b63758a93c5ac9dec9d19187cc4f60dcf7296b417343fd3fb6bf784731b4a" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init"
      assert_predicate testpath/"empty/site/index.html", :exist?
    end
  end
end
