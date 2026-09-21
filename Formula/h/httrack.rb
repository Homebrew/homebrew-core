class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.50.3/httrack-3.50.3.tar.gz"
  sha256 "644d4ec0e48ad596dacd7f8017b68d8a3f1dfc140284b412b53086e7d1664e9d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "92ef4b3974644bc66f60818f7de4e62bb99df8461bf4d4cb0a417efe77d59e69"
    sha256 arm64_tahoe:       "0738bb348f504b2c43361e838c92269163cc1a5050ab45f818b6e49de255cd7b"
    sha256 arm64_sequoia:     "faa778c34725e17e88a5f7221136000e9e8267a2b76505e8570304386a856ecd"
    sha256 arm64_linux:       "ef64035f345dbae2c9905546ce48338a098e9814126452547396b3d9ff453da9"
    sha256 x86_64_linux:      "04c3866abb8d42699d292e8c3b7297afe91183731db04460dfe07f2f13c62549"
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
