class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.27.tar.gz"
  sha256 "63d02788852644d871746e1a7a1d16c272c583c226f62576f5ad232a6a44e18c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7fc128f00d5170584104e0c4c49e4307043fd3ba3db125792138dab3279853b9"
    sha256 cellar: :any,                 arm64_ventura:  "e763d80b575c27eb381f559494636cb7737a0721f884d98523d0452911262273"
    sha256 cellar: :any,                 arm64_monterey: "203b85ed98819720e7f40971f9978956b4fd458133a3935f402a10dfc2ab85b5"
    sha256 cellar: :any,                 arm64_big_sur:  "8d4405a65463be4dc6b5472b2cff454301591e57ff5c3b5fb4e8e40fb6981a66"
    sha256 cellar: :any,                 sonoma:         "2dd57b621d3107d7d4b5d4486a4cfe82035e81c45042c304f81b389bb20ae2d6"
    sha256 cellar: :any,                 ventura:        "3c949be5b7c5dd7f64b427e4bc90599c3bc8101deb6bf1b282eebb42312b10c8"
    sha256 cellar: :any,                 monterey:       "07bd1f48953cef8653bc75f23fcbf9fab5de45a3551d7ba7f23db22e558b9247"
    sha256 cellar: :any,                 big_sur:        "4abde2a6a123b3816945f79b07c760b95d2709fc791b5c5c7509d9ed1544e491"
    sha256 cellar: :any,                 catalina:       "2405af18c4c1b4c2573c221ff6699afcb37a42fe211ebb8b726314d31e13ce1a"
    sha256 cellar: :any,                 mojave:         "e40398cff74d597a3c0f203c59906b8276d3985a976c87812269bdc56ee06c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396c081539899c3450ea38767fe2d33e547367da9351bb7c2726c7455516fcad"
  end

  # Deprecation date set to 1 year after upstream issue was created.
  # Issue opened on 2022-07-29: https://github.com/Yubico/yubico-pam/issues/242
  disable! date: "2024-08-03", because: "uses deprecated `ykclient`"

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}",
                          "--with-libykclient-prefix=#{Formula["ykclient"].opt_prefix}"
    system "make", "install"
  end

  test do
    # Not much more to test without an actual yubikey device.
    system bin/"ykpamcfg", "-V"
  end
end
