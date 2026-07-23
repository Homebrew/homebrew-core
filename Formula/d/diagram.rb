class Diagram < Formula
  desc "CLI app to convert ASCII arts into hand drawn diagrams"
  homepage "https://github.com/esimov/diagram"
  url "https://github.com/esimov/diagram/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f88bc99975ade753435ecf0e7a6470611f77563eb73b94d56fa6b6bafb4b8561"
  license "MIT"
  head "https://github.com/esimov/diagram.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "3a77e7b6637b987d6391891b8810a495e7043b8311b2308acba17be9fb1763e5"
    sha256 arm64_sequoia: "7a4c9251da9103d6c7bf749ae76e30500e2298751c6743ff0ddb27fdb2203e08"
    sha256 arm64_sonoma:  "0d6928b6450255451e2120814add95222db5add55282cc2f9477766b6cd4607f"
    sha256 arm64_ventura: "aea4fe2d174931f81ca241d51510b1d5dfbf4034e1cc77d9eb86646859450e05"
    sha256 sonoma:        "9fdea25d43a0954d98c691c9b34bde4a0ab10a18e5b5b6d5fdfc1d1286c29e8c"
    sha256 ventura:       "bfdfb5a4c9c981dceedc86608888e1e1a6100e0f98f2fe397d411485a3762ce4"
    sha256 arm64_linux:   "8d40ae4f041e7e48859c91c4875605960d20ffa8de18b35953e9a783031d524f"
    sha256 x86_64_linux:  "8ba93efdc8407ebd4f76c6f3a78aaf392e8a177035d48d740d4c9e3412bc8746"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for gioui.org/internal/vk)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.defaultFontFile=#{pkgshare}/gloriahallelujah.ttf")

    pkgshare.install ["sample.txt", "font/gloriahallelujah.ttf"]
  end

  test do
    cp pkgshare/"sample.txt", testpath
    pid = spawn bin/"diagram", "-in", "sample.txt", "-out", testpath/"output.png"
    sleep 1
    assert_path_exists testpath/"output.png"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
