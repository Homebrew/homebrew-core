class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "bd73a4b6f9fe502d140c9d5d3c972d85dccb53f4222afeb8260e97f1f95b96b0"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e187a22028771da734e7e097dbaf49523634c1c9c25e62fcd947fd28d33991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d54c89e27fff3e0f7a0542ca4b022c4f87b9bfd6665efab652954f662e08fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e048bc6e25bf4a7ea0035ce09d353743b57af4f0b9b13c731162f589b10432e"
    sha256 cellar: :any_skip_relocation, sonoma:        "db7277bfdebe5777098a8a19d3b598c905b9e74e76dd9a9436eab572faaf702f"
    sha256 cellar: :any,                 arm64_linux:   "9f6d5a2a3dbc371596d841cec8a917f5b942738352363ee352e474df8551b757"
    sha256 cellar: :any,                 x86_64_linux:  "33405ce85e7ab4f5bc5fd13689ea6eef5ec73a73cc1d967bfb9b7ff1e2f4a723"
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
