class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.49.23/httrack-3.49.23.tar.gz"
  sha256 "b91bae2e157e708553e12619702af8e22185d784954ce3ec3553add30b368584"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "cd14fa0d9ec9f471610c771b79e7199315baa61c97f25901bb396be3c1cabd0c"
    sha256 arm64_sequoia: "249818cdc25ff8c61754e1bff47f978be2d2036fe4306817a6897e395ef06d3f"
    sha256 arm64_sonoma:  "2920d7c37133e4f7321a77badc2e87a743af08a5d26d2cfb273c16e95015e5d7"
    sha256 sonoma:        "77c4e17ced468dc4db08c3b539f7b8f018fef2808ec8a838b3f2872fece9f1ac"
    sha256 arm64_linux:   "5d8aff0fb17cc3dd679f7388f62aa5d68350c14123a3e5cb8bcd61192eadf53a"
    sha256 x86_64_linux:  "3990f0fe8f70d632c510e3e31b88fbdc143fe3108a4ac0507e6fb3341465d439"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_r(Dir["#{share}/{applications,pixmaps}"])
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end
