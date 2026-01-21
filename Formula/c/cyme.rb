class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.10.tar.gz"
  sha256 "53246a12e1feb09c5301dc1d391c574ad38ab909c301db1a79628445945c2425"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7129fe26690dc15dc362a9e512fa9c4035879010c57a79dcab20189b9832e802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa389afe9b7a13815e7864f63f55b673a539caa022eb07b96d8e869472bedb08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b643f1da9a538bc8e5c3553ca04dd7418f5ee36a22548f4ac5217444282371c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1dc74e6a430f4b6809223eb8a009f6c61d640369aaa1710c5b374f4cf1e671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3265c657bbbe058d4264c07d6f9c1d3e1c7b6605e2956cc446ac762cbcb22e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8e03fedddf86201d1a3b68145d8872a0c83e1c8213521ca8a1db8d8a4d0a66"
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
        └──○    1   2 0x8087 0x0020 Integrated Rate Matching Hub - usb
           └──○    5   4 0x17ef 0x1005 ThinkPad X200 Ultrabase (42X4963 ) - usb
              └──○    4   7 0x05f3 0x0081 Kinesis Keyboard Hub - usb
                 └──○    2   9 0x05f3 0x0007 Kinesis Advantage PRO MPC/USB Keyboard - usb
      EOS
    else
      assert_predicate output["buses"], :present?
    end
  end
end
