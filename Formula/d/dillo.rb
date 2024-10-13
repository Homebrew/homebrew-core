class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https://dillo-browser.github.io/"
  url "https://github.com/dillo-browser/dillo/releases/download/v3.1.1/dillo-3.1.1.tar.bz2"
  sha256 "5b85adc2315cff1f6cc29c4fa7e285a964cc3adb7b4cd652349c178292a4fb9e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "f6d6810081fbf6d7fc7eee4364ea8ed8783390401f1725bb4d7735256f5d32e8"
    sha256 arm64_sonoma:   "7659f9a43d50f1bbb57cbcf772e0678fd8450ce7e11449a99c1e6c2191c7ccdb"
    sha256 arm64_ventura:  "988cd2898a45ab880b51f51803baccbae409468c18e329b3f3ee406fa783628c"
    sha256 arm64_monterey: "d1870bc65b0e048eb642b1853f7b31526327160df24e6f9dda1a6c18976ba22c"
    sha256 sonoma:         "b1a7d562d451d28fb2d2d16c894c070271dd4425bc33955d6dcb5c859466a482"
    sha256 ventura:        "f7f73f1ce2a1c5ed69287182e8d870a366209dde19a76e49f547803468b16a95"
    sha256 monterey:       "049ba3e72f9a0cf75e62f4ab6dfce2a11b383e06e253fe2d8a5c7223487cb97f"
    sha256 x86_64_linux:   "fd6127a85c1bbabba2446009df8eb6bd91a9fc182b79cf6d259167fe23bfe69c"
  end

  head do
    url "https://github.com/dillo-browser/dillo.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "fltk"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
  end

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    test_file = testpath/"test.html"
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    EOS

    # create bunch of dillo resource files
    (testpath/".dillo").mkpath
    (testpath/".dillo/dillorc").write ""
    (testpath/".dillo/keysrc").write ""
    (testpath/".dillo/domainrc").write ""
    (testpath/".dillo/hsts_preload").write ""

    begin
      PTY.spawn(bin/"dillo", test_file) do |_r, _w, pid|
        sleep 2
        Process.kill("TERM", pid)
      end
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "DEFAULT DENY", (testpath/".dillo/cookiesrc").read

    assert_match "Dillo version #{version}", shell_output("#{bin}/dillo --version")
  end
end
