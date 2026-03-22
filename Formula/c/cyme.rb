class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.11.tar.gz"
  sha256 "198afba2fc76792db9f08dfda13840aa98dbbfe0ed66238c15305fe0fdf55cf0"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dfc959a50263654b3a555dd406ba225f20b9eccd190abbba9abac236f343e0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e292a2d24672bea27ac660119ccba4a618a93108fe1e0e12378b20c62c3733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88cd225d7703409dd1706ae5f8e4030659a0e7fbd860e421bce2288fbfe5505"
    sha256 cellar: :any_skip_relocation, sonoma:        "48bb8e6fdc8e229db6d43827b9ddb4a7c8101edd730f38c956e1f4c291f0ab1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219a07273a0ebe6e61a50c190fd07f63a30212684dbb8bcafc0200b448c922d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7ec820d877989529135e06bbc54c5d5e142f7551ea1ae317ff84112cb47337"
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
