class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.9.2.tar.gz"
  sha256 "e2f6a44e5422527f1a6c582f371b637fefa9f0420c25cbce5831b1c95a2c91c9"

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
