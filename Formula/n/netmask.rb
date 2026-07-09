class Netmask < Formula
  desc "IP address netmask generation utility"
  homepage "https://github.com/tlby/netmask"
  url "https://github.com/tlby/netmask/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f352d8117a4f9377a15919d9ad4989cfba8816958718a914abf1414242a9f636"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cb0530aeaef1e274a3e3457b498d583424b9558fbb4647b20ff0d5020a46cb55"
    sha256 cellar: :any,                 arm64_sequoia: "378d351713f5eea2019eaea0b601dc206a9dd6a0a3235dd77d450e908876f2b7"
    sha256 cellar: :any,                 arm64_sonoma:  "d4229b7337b45ee6950de060d01bf4dcaf0d4588152e3e8a765e5b0cae9119fb"
    sha256 cellar: :any,                 sonoma:        "62421d9e2ff7f4a5f547531b580132eb1732d8d9aa5df3fdcb644e8b170b6a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1fc97a92cfc5d50e0a561fd8744b6a3050ea1f42acc152eca977514ae3e6750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc66aefa5400e4501b5b66157e684899d3790074ae8fc4b163edd957d931c7ba"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "check"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "100.64.0.0/10", shell_output("#{bin}/netmask -c 100.64.0.0:100.127.255.255").strip
  end
end
