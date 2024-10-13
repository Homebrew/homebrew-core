class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "6b7781294cc84d383c7e7ecd05af08ca8d9b2af7a49ba648178ae4d84837c52b"
  license "BSD-3-Clause"
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b8ca23a0fe897b848f8fbe19273bf1e78793f7b0f9ec2ff9399173f4d8af7f1a"
    sha256 cellar: :any,                 arm64_sonoma:   "e94dd8359b362248a2add9bb60bdd7eaf096290b5fada5d73b8c8cfa86ea79da"
    sha256 cellar: :any,                 arm64_ventura:  "c74be0abfd3c227042b2be63c13207a9e6b72c228ab9c027d1f8c0ecd89f6abe"
    sha256 cellar: :any,                 arm64_monterey: "34da6aa20a69ca6f79afff001898af9994b697331815b44ae572a05c25dda7e4"
    sha256 cellar: :any,                 sonoma:         "f62dc78d90d3d02d3d0ea7f4d4d3d82b13affcdc403955113ec0d73d56c74fc3"
    sha256 cellar: :any,                 ventura:        "22cb1b17edbddfc17bf64112a60d32fd659dfadce8cf1521018b994f89194f0d"
    sha256 cellar: :any,                 monterey:       "a2ec7d1750d1c8d4370679e255f75957f6365bb55259b21967216ea5549ee88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44137a86b9210566d60a3b8b8e09f5cca01340f2db9441c6a29375df8e8e6db9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
    (testpath/"config.csv").write <<~EOS
      null:#{base_port},:#{base_port + 1}-#{base_port + 101}
    EOS

    fork do
      exec "#{bin}/ios_webkit_debug_proxy", "-c", testpath/"config.csv"
    end

    sleep(2)
    assert_match "iOS Devices:", shell_output("curl localhost:#{base_port}")
  end
end
