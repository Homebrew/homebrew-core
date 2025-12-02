class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "768f101612bf5d2507957f10a8e34e98675ea8fe3c63b8ed78772f8abd103fbf"
  license "BSD-3-Clause"
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c79d6aaae9beba337352d712a586104f7a3077e5d4ea9cbcd50c1603495b409f"
    sha256 cellar: :any,                 arm64_sequoia: "878606bc7a7c42583c379a8f9713820531dc4e5eeeacc477289f9d7590cca6b7"
    sha256 cellar: :any,                 arm64_sonoma:  "2fad8ed6dc4a59daeb709bd10f69f7bdf8eb50b7d8e1d5e233172422b25adfad"
    sha256 cellar: :any,                 arm64_ventura: "c1e3ef891cfe774490f533c4149121064d4ad643e248940ba7735c95a80874ad"
    sha256 cellar: :any,                 sonoma:        "7c8b1b853f68361cecff8b2381ef54476e0e739f9834d71dccf42e8732708c16"
    sha256 cellar: :any,                 ventura:       "31f5c733af39160d923f3f8a7ddbe239cf912c0c38df56677411fe81014c2565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83e58d00a3cb9b705be17b8263be3d196fd60e7f59de50c1d6ff2a243bee8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50df7f8e566369e2053f177d72b37e768ca3c047afcfc27965313b4aa13651d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libusbmuxd"
  depends_on "openssl@3"

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ios_webkit_debug_proxy --version")

    # Fails in Linux CI with "`No device found, is it plugged in?`"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    base_port = free_port
    (testpath/"config.csv").write <<~CSV
      null:#{base_port},:#{base_port + 1}-#{base_port + 101}
    CSV

    spawn "#{bin}/ios_webkit_debug_proxy", "-c", testpath/"config.csv"
    sleep 2
    assert_match "iOS Devices:", shell_output("curl localhost:#{base_port}")
  end
end
