class Elf2uf2Rs < Formula
  desc "Convert ELF files to UF2 for USB Flashing Bootloaders"
  homepage "https://github.com/JoNil/elf2uf2-rs"
  url "https://github.com/JoNil/elf2uf2-rs/archive/refs/tags/2.1.1.tar.gz"
  sha256 "c6845f696112193bbe6517ab0c9b9fc85dff1083911557212412e07c506ccd7c"
  license "0BSD"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bfbfb63a90f1f2f226d6eea8d4a0fb946bac13b9d09c30add16176cfc12745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e82da1e4bda8f4e9b96a224bd39f0fa553df1f2b2f5685e3d26ea8d36db64ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad84d3c1063a64c46201c1f3848ae783cf238e63dd215470e908642153d4eadd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d8ad586061ca0882a16789b7242c86801e76389e525657ba1864ea33084dae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49813f898c7f808ceb5ec486e6336e5c05e78ac6eb28835eb19b25c2a12e56e"
    sha256 cellar: :any_skip_relocation, ventura:       "459684a3cb259a2aba995e088130a2f9724c1589a7cbd11e9e4380ba1238024b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb8bd88d07dec80d7314766dd10b94d6ea0d9e3f1fd60129528549745da19c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41046fe0f99aac047708fdb2204bb12220625173156e477322e7bd13f09c27e8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  # Fix compatibility issues with latest Rust: https://github.com/JoNil/elf2uf2-rs/issues/40, https://github.com/JoNil/elf2uf2-rs/pull/41
  patch do
    url "https://github.com/JoNil/elf2uf2-rs/commit/c1639b9e8bcaaaab653f9fa0e358fed0e8a7ce76.patch?full_index=1"
    sha256 "3bbcfa39c01bd705f7b021c1e5117bd9a91fa51c4c13c998a43ba17adf9616a7"
  end

  def install
    system "cargo", "install", *std_cargo_args
    (pkgshare/"examples").install Dir.glob("*.elf")
    (pkgshare/"examples").install Dir.glob("*.uf2")
  end

  test do
    system bin/"elf2uf2-rs", pkgshare/"examples"/"hello_usb.elf", "converted.uf2"
    assert compare_file pkgshare/"examples"/"hello_usb.uf2", testpath/"converted.uf2"
  end
end
