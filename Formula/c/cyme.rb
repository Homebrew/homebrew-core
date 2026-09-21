class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "1ac9956cc768d4482138455ce71fb5d62b816057dc34c181096a36be27735e0d"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53f3c16e9b77990d7c17fb9f8191c54975348396cd0640be6d5272dadea3764b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c061f12466bdf6cb438e909c590dc131390f134be7d5cc74b6eaaebcdd58cd1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "378e108762ab42d3030f112051bbabf05522a975e283d53293e801fd8ada6246"
    sha256 cellar: :any,                 arm64_linux:       "53e6ca51f321c4b9c483b3409fe23e7d99478f9e9aa6268b81d64552bfa5a114"
    sha256 cellar: :any,                 x86_64_linux:      "27850a485a691de15725f1151021485db5f2f2afc4ecbacd726aebf609b71520"
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

      umockdev_run = "#{formula_opt_bin("umockdev")}/umockdev-run --device usbkbd.umockdev"
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
