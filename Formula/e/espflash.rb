class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "e17e14bae62c8cb4fe3b2b1e5bb5b07b1d988cbab97fb2fed0377ca85a4b5998"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba82c7ba174b27bdbf307ec011be8fc20a5775079c9ae6d044788a7bd330c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0253653d8e17bfcc97644d2199b43443db26cc1b4bd298a7055afc86c39ca1bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673d3490bae0056354373b56f53fbbc1a53312435f652278c32e01d30b8881ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f004c0741170c43f90ed6e490ba56a320ea49f79079bca74c736d3818684ab0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb2a05f59acc95fc17b8e88eb832571be8f6c4bb360adf393ac8a746b94f9854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4a3065c3f999e04323732137d9ab797d8b6a229e5743a5c385bc343aa15171"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "espflash")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/espflash --version")

    output = shell_output("#{bin}/espflash flash espflash/tests/resources/esp32_hal_blinky --port COMX 2>&1", 1)
    assert_match "Error while connecting to device", output
  end
end
