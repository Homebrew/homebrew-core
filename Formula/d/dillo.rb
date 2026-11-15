class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https://dillo-browser.org/"
  url "https://dillo-browser.org/release/3.3.0/dillo-3.3.0.tar.gz"
  sha256 "db1863261d5efbd27b090e430c88064082b891cea1edf7a14e234cca51754f60"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://dillo-browser.org/release/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_golden_gate: "9e53e2905cfea454df590baf4ffba3565df42dc44997b2beb634f527d4ff5aea"
    sha256 arm64_tahoe:       "714182643dd7271f7db53ea0a741f169814781a5ed38dfce7cc4c00ff8553145"
    sha256 arm64_sequoia:     "fb195740b308915c58205ea9dd0a0b2c8984671073a4325af5d5fe924a64d5d5"
    sha256 arm64_linux:       "f351f9265065ca1f811fa2bedf39eb14d5127004d3e6e926f84d396f5b82ba70"
    sha256 x86_64_linux:      "bafdfc3c73412595199131270a760b6c80a2f34d5432263b0caea40a7112f11e"
  end

  head do
    url "https://git.dillo-browser.org/dillo/", using: :git, branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  # TODO: Switch to unversioned `fltk` when possible.
  # https://github.com/dillo-browser/dillo/issues/246
  depends_on "fltk@1.3"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openssl@4"

  on_linux do
    depends_on "brotli"
    depends_on "libx11"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    HTML

    # create bunch of dillo resource files
    (testpath/".dillo").mkpath
    (testpath/".dillo/dillorc").write ""
    (testpath/".dillo/keysrc").write ""
    (testpath/".dillo/domainrc").write ""
    (testpath/".dillo/hsts_preload").write ""

    begin
      PTY.spawn(bin/"dillo", test_file) do |_r, _w, pid|
        sleep 15
        Process.kill("TERM", pid)
      end
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "DEFAULT DENY", (testpath/".dillo/cookiesrc").read

    assert_match version.to_s, shell_output("#{bin}/dillo --version")
  end
end
