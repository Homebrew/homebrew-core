class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.9.3.tar.gz"
  sha256 "0fa019cfd5babb85ba443fc5b5167a43c703c09695327726fca8afbf91b435f7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e827ecb693054dfbf0650fc8b0a34ab58f13e065a6de410130703d0850aacb08" => :catalina
    sha256 "46732beed14ac4265f06325e80bc5c7ade918418d371222a0f7171bbd6c5a189" => :mojave
    sha256 "42d6a2e0f41b73144e2126b0943093567095676a16615ebde7c07416cbb7d8de" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
