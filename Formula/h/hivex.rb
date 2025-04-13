class Hivex < Formula
  desc "Library and tools for extracting the contents of Windows Registry hive files"
  homepage "https://libguestfs.org"
  url "https://download.libguestfs.org/hivex/hivex-1.3.24.tar.gz"
  sha256 "a52fa45cecc9a78adb2d28605d68261e4f1fd4514a778a5473013d2ccc8a193c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-only"]

  livecheck do
    url "https://download.libguestfs.org/hivex/"
    regex(/href=.*?hivex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "56591673b746f964c9a11aa5d00f3f7414aecaf44189650e7542eef6796a56a5"
    sha256 cellar: :any, arm64_sonoma:   "fec44a3603f70ad668b8340f75d5c2efd21eec82d87dbdf9e7c6272f9e41ac87"
    sha256 cellar: :any, arm64_ventura:  "2788843263f4b80761e8c47fd4c565a2b17c740ea786b6d3c07a56cb548e9cc9"
    sha256 cellar: :any, arm64_monterey: "4f43e6cb50e86f7035276b2f80d5f158329c3320caa06eef2f7b7cd25799584f"
    sha256 cellar: :any, sonoma:         "b02c58d064c1463fbb8375839a8a43d4511f9e7869f934e26dfd4471a3493b76"
    sha256 cellar: :any, ventura:        "be3ab0e828697756aef7048c02c6c9be7f2e05b7eb1445822931371f11309093"
    sha256 cellar: :any, monterey:       "bc1a776d2a57db7b102fb788d7b7c2a7fd3b6d753df57b4881c911c99a0c0928"
    sha256               arm64_linux:    "ae8bb40fdea46651ab1105f9c50c1bb1001809398414452f4ca597b0db5f8654"
    sha256               x86_64_linux:   "521ab163122aa40680fe0473ca6ea2f77fdb877ac4ef417dfff93eef66608a0b"
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Use `-ld_classic` to work around `-Wl,-M` usage
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = %w[
      --disable-ocaml
      --disable-perl
      --disable-python
      --disable-ruby
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"test").install "images/large"
  end

  test do
    assert_equal "305419896", shell_output("#{bin}/hivexget #{pkgshare}/test/large 'A\\A giant' B").chomp
  end
end
