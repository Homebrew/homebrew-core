class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.14/axel-2.17.14.tar.xz"
  sha256 "938ee7c8c478bf6fcc82359bbf9576f298033e8b13908e53e3ea9c45c1443693"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "1f8ad603fc44127acc3b97b453360043ffa0610d63248035509a8b9c70d93fdc"
    sha256 cellar: :any, arm64_sequoia:  "b916766161940b92547f4dfddcc72ff0a7138c773e935927e0c8ae3111076494"
    sha256 cellar: :any, arm64_sonoma:   "3304a247f8e410cf41737d083bb6611d74bb5991d7cec6d76b48d9ce2e944423"
    sha256 cellar: :any, arm64_ventura:  "0b24ce8df8e83157f4558afcb41083993d7b7aa5dbf02e06b01037a665a63ae5"
    sha256 cellar: :any, arm64_monterey: "a5ac14c819bb4bc61c7f9b1c9b8211bbc14e83c9db8a3c301f58abaf822de463"
    sha256 cellar: :any, sonoma:         "10439c6710098fb8022d91ce619e8c459810845beee5d20f2aab33c6cf1a13df"
    sha256 cellar: :any, ventura:        "5ca2bc10eba04c8efaf32c380ac81f6b3da6a3a8a0dd28013a9000d06a76dd4e"
    sha256 cellar: :any, monterey:       "70f5c6208758d713185fe924ef3778b4a72e81c29660b495c1cdab5c2e968685"
    sha256               arm64_linux:    "5a1e69568f0649bd3fc53694bf840b8a626e507c11cbb12496b8485ac82553af"
    sha256               x86_64_linux:   "bf422304c452796fc7a1c020f7bf067fe1ff5eb7be4757a56b249eef815dfa9d"
  end

  head do
    url "https://github.com/axel-download-accelerator/axel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gawk" => :build
    depends_on "gettext" => :build
    depends_on "txt2man" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_path_exists testpath/"axel.tar.gz"
  end
end
