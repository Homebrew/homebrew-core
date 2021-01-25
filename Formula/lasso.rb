class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.6.1.tar.gz"
  sha256 "f8a8dbce238802f6bb9c3b8bd528b4dce2a1dc44e2d34d8d839aa54fbc8ed1de"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "83fa7671b9b8635dbf79c5db616d72c0f8d53ca543a508effd4bf628f46af26e" => :big_sur
    sha256 "aef8a4d9b81790ff84aad53da1c7d9a582ac69db8d775d930a30444174e186dc" => :arm64_big_sur
    sha256 "bc1f4dc6fccff1c5631d37b4539d2d9a657357445488ce892756feccf98f660b" => :catalina
    sha256 "d4bfe838fe8fd0b32ff7e19a4601c85a3b98a49ed8e1f05dc796ed5adf89005b" => :mojave
    sha256 "8256178a39f08386db515226b334a93f895cb8d96c043acfe1a8d420efbb668f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "glib"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{MacOS.sdk_path}/usr/include/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
