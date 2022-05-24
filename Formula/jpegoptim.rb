class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.7.tar.gz"
  sha256 "9d2a13b7c531d122f360209422645206931c74ada76497c4aeb953610f0d70c1"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8d8940a75e3fb32f7ad434f214d793a0ef30fe83c9e7cf22f6a9e5a13f0f7df"
    sha256 cellar: :any,                 arm64_big_sur:  "74f6b6eec2834729de1a29478a5436ef2457d7bd91af03a3da8709f225c07a45"
    sha256 cellar: :any,                 monterey:       "daf609700653d6b983e782785a07ca608251372b5a723d6eaa0690f070df362c"
    sha256 cellar: :any,                 big_sur:        "1dc492177f3bf6aa90d6bbc88fa62194fc6654038b62d64442a14c0621b54ed4"
    sha256 cellar: :any,                 catalina:       "dcab93fd24b80d50e3b3a460bc37559391246c05fd9037897c3d239a2f97a481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02b5e35d2887c7bc6e8c84ccfa1f6df8991b2bc33f7202f250096c8e1daeb950"
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
