class BtrfsProgs < Formula
  desc "Userspace utilities to manage btrfs filesystems"
  homepage "https://btrfs.wiki.kernel.org/index.php/Main_Page"
  url "https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v6.2.2.tar.xz"
  sha256 "e4888db8637d92e667448386992d0856b954cf2515b98d39b667da43c482d693"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.1-or-later", # libbtrfsutil
  ]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/"
    regex(/href=.*?btrfs-progs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94a8e153ee9e6117507606e1bac866cb68ef00a52d9e936861d1916d603de7c5"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "e2fsprogs"
  depends_on :linux
  depends_on "lzo"
  depends_on "systemd" # for libudev
  depends_on "util-linux"
  depends_on "zlib"
  depends_on "zstd"

  def install
    system "./configure", "--disable-python", *std_configure_args
    # Override `udevdir` since Homebrew's `pkg-config udev --variable=udevdir` output
    # is #{Formula["systemd"].lib}/udev. This path is used to install udev rules.
    system "make", "install", "V=1", "udevdir=#{lib}/udev"
    bash_completion.install "btrfs-completion" => "btrfs"

    # We don't use the make target `install_python` due to Homebrew's prefix scheme patch
    cd "libbtrfsutil/python" do
      python3 = "python3.11"
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
  end

  test do
    device = testpath/"test.img"
    system "truncate", "-s", "128M", device

    output = shell_output("#{bin}/mkfs.btrfs #{device}")
    assert_match(/Filesystem size:\s*128\.00MiB/, output)
    output = shell_output("#{bin}/btrfs filesystem show #{device}")
    assert_match "Total devices 1 FS bytes used 144.00KiB", output

    system "python3.11", "-c", "import btrfsutil"
  end
end
