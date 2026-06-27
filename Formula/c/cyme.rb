class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "1d0f712d39f5d747f900829b6b9cccbfa943637b4c14d60e8a6a505162174c82"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cc05bde0b3821753aeea827c615de39751c352f95f1a8efbd6df99709936a76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da52e6135880f44c37c189ed96598c90d0bd85788068651091c9ba47694e181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc345525751acb619d78cbe4506b1e5d9d83b8da3942fabfebc8bc0a123d3e56"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dfe0d7db63f71537976e9b2a06fbc9f740f84f2405880d9fd718b5501a4a494"
    sha256 cellar: :any,                 arm64_linux:   "ca5e1a1f079ed227f7c376c65603d4df03326bff11b770ca33f0cd2d3ea17c47"
    sha256 cellar: :any,                 x86_64_linux:  "9ff3f86ba6c3a73e4b51efd512a6a448b6564efe8fe3701b63af38950743fabd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "umockdev" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_includes output, "buses"

    if OS.linux?
      # Mock USB devices using example from umockdev
      resource "usbkbd.umockdev" do
        url "https://raw.githubusercontent.com/martinpitt/umockdev/1b58d24fb78e8297f2b0e96abb99fcbee7f37784/devices/input/usbkbd.umockdev"
        sha256 "cc7d5b277531630dbe7d93a74d24ff13f7740c5f96f6933b3ba8d1db54e25b7a"
      end
      resource("usbkbd.umockdev").stage(testpath)

      umockdev_run = "#{Formula["umockdev"].bin}/umockdev-run --device usbkbd.umockdev"
      assert_equal <<~EOS, shell_output("#{umockdev_run} -- #{bin}/cyme --no-padding --tree")
        ● 1-0 EHCI Host Controller Linux 3.10.0-2-generic ehci_hcd -
        └──⊛    1   2 0x8087 0x0020 Integrated Rate Matching Hub - usb
           └──⊛    5   4 0x17ef 0x1005 ThinkPad X200 Ultrabase (42X4963 ) - usb
              └──⊛    4   7 0x05f3 0x0081 Kinesis Keyboard Hub - usb
                 └──○    2   9 0x05f3 0x0007 Kinesis Advantage PRO MPC/USB Keyboard - usb
      EOS
    else
      assert_predicate output["buses"], :present?
    end
  end
end
