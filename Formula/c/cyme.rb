class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f4aefd2ac447f6ca6040f9d22376a8fdd96d30f1612fca3cfacf5399aef68db0"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd218e60b8dbd014b0a07bab1cae84200e8b1ce98a5851cc07fe81365d7acc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca3443bf4cca0e9808a2f1e6de7478e540938c367297f2115b2d46583701586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c0ae87adaa7b859ccb7c2aaba7d6c6b85ae45d54a328a851ba5d6d0a486d357"
    sha256 cellar: :any_skip_relocation, sonoma:        "a48aaae0daddad9008792ae91b2ccac2bb6df1842384074afa872342690fb83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61758f7cf306a011e3367aaedd528b17aa0732f70b2477b910002746a4ba436f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7deba41de02fb89fa5f97a2e667a3af6c851971b105ea493bdee7e014f54e217"
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
