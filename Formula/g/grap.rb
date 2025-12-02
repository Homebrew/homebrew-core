class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "https://www.lunabase.org/~faber/Vault/software/grap/"
  url "https://www.lunabase.org/~faber/Vault/software/grap/grap-1.49.tar.gz"
  sha256 "f0bc7f09641a5ec42f019da64b0b2420d95c223b91b3778ae73cb68acfdf4e23"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?grap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2fcedf83a80e2a8f119cc9618c9b7ea778da28290c424e35ad9bac0c772f0d72"
    sha256 arm64_sequoia: "7847dda0c19b96bed615ddf354dd379ce1954df1ee54f8fbd2c19c43152dbec8"
    sha256 arm64_sonoma:  "dc6ca606b2d6dfa9844fa39f2b93369fd5a275e76177b491125f50af44108cde"
    sha256 arm64_ventura: "eae74133e7bc44b9056719289af7c55c9e4445a3979431718a4286836ce3d679"
    sha256 sonoma:        "de789bd8018007ae3c23bc17ecc0adf2e5f9d72f6ccf2898fb8e86ec6066cdce"
    sha256 ventura:       "41074c98b53d60b6cdbed6f9a90335cc5b4e23e0353cc960e8f25b7a3f2e42e6"
    sha256 arm64_linux:   "10db4a042d10701644180a0dcf58c55a60a8ca6003af590fa134bd67607ccacc"
    sha256 x86_64_linux:  "523b5f43f7e49ca1ac6c35bb1ced2a1c1fdca3852a80568494a4de497696ab67"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<~EOS
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
