class Libefi < Formula
  desc "Base EFI runtime library"
  homepage "https://github.com/rickmark/gnu-efi"
  url "https://github.com/rickmark/gnu-efi/archive/v1.0.tar.gz"
  sha256 "7eadece64bd593885d2d76bd5e69910ad1b246e98387df915fa15d029bf0ab45"

  depends_on "gcc" => :build

  def install
    system "make"

    include.install Dir["inc/*.h"]

    (include/"protocol").mkdir
    (include/"protocol").install Dir["inc/protocol/*.h"]

    (include/"x86_64").mkdir
    (include/"x86_64").install Dir["inc/x86_64/*.h"]

    lib.install "x86_64/lib/libefi.a"
    lib.install "x86_64/gnuefi/crt0-efi-x86_64.o"
    lib.install "x86_64/gnuefi/libgnuefi.a"
  end

  test do
  end
end
