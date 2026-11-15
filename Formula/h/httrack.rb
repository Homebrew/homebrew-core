class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.51.0/httrack-3.51.0.tar.gz"
  sha256 "1daa7ec0153ec16e6bea809c2d8829ceddf0e06f74471fa0528ffbf20275f5f1"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_golden_gate: "4316907b3240798feb96c0ccac246806d4c502ade968c066ed2b9cc44ecec386"
    sha256 arm64_tahoe:       "734be379b4d142c51786562ff8378033c673e5d59f6cefd8d407f7feaa162d4d"
    sha256 arm64_sequoia:     "4a0d677e57916c1017c1145b976154f0c2e7dafe6c885e3904413a696cf8e5f6"
    sha256 arm64_linux:       "e38289df30e88de0e038c264c1c6871b50767a3938233756bf22d8098480cc2b"
    sha256 x86_64_linux:      "b961010bc9552db428f695e8a5521bc828bc93ab4260868758ae66a4537e2186"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Gnome integration is inert on macOS, but Linux desktops use it
    rm_r(Dir["#{share}/{applications,pixmaps,icons,metainfo}"]) if OS.mac?
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end
