class BtrfsProgs < Formula
  desc "Userspace utilities to manage btrfs filesystems"
  homepage "https://btrfs.readthedocs.io/en/latest/"
  url "https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v6.19.tar.xz"
  sha256 "ad6b791a60eb563d3314bc18e3c47f6b053a032639488b5b09b9d5e7921de6b6"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.1-or-later", # libbtrfsutil
  ]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/"
    regex(/href=.*?btrfs-progs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0db6518924a45b74b4a4977e64a79831b532c02b2033c09cf8f933cca26e0584"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "deee61a9fcbc7117ede27db9161efa6ba5396e3f11ee0c29ee075a3d687b0cb2"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "e2fsprogs"
  depends_on :linux
  depends_on "lzo"
  depends_on "systemd" # for libudev
  depends_on "util-linux"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  def python3
    which("python3.14")
  end

  # remove sphinx-rtd-theme extension for html docs
  patch :DATA

  def install
    system "./configure", "--disable-python", *std_configure_args
    # Override `udevdir` since Homebrew's `pkg-config udev --variable=udevdir` output
    # is #{Formula["systemd"].lib}/udev. This path is used to install udev rules.
    system "make", "install", "V=1", "udevdir=#{lib}/udev"
    bash_completion.install "btrfs-completion" => "btrfs"

    # We don't use the make target `install_python` due to Homebrew's prefix scheme patch
    system python3, "-m", "pip", "install", *std_pip_args, "./libbtrfsutil/python"
  end

  test do
    device = testpath/"test.img"
    system "truncate", "-s", "128M", device

    output = shell_output("#{bin}/mkfs.btrfs #{device}")
    assert_match(/Filesystem size:\s*128\.00MiB/, output)
    output = shell_output("#{bin}/btrfs filesystem show #{device}")
    assert_match "Total devices 1 FS bytes used 160.00KiB", output

    system python3, "-c", "import btrfsutil"
  end
end

__END__
diff --git a/Documentation/conf.py b/Documentation/conf.py
index 7d90916..4550842 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -33,10 +33,6 @@ templates_path = ['_templates']
 # This pattern also affects html_static_path and html_extra_path.
 exclude_patterns = ['_build']
 
-# The theme to use for HTML and HTML Help pages.  See the documentation for
-# a list of builtin themes.
-html_theme = 'sphinx_rtd_theme'
-
 html_theme_options = {
     'navigation_with_keys': True
 }
@@ -80,8 +76,6 @@ man_pages = [
     ('btrfs-man5', 'btrfs', 'topics about the BTRFS filesystem (mount options, supported file attributes and other)', '', 5),
 ]
 
-extensions = [ 'sphinx_rtd_theme' ]
-
 # Cross reference with document and label
 # Syntax: :docref`Title <rawdocname:label>`
 # Backends: html, man, others
