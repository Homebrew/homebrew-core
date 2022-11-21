class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.101/msitools-0.101.tar.xz"
  sha256 "0cc4d2e0d108fa6f2b4085b9a97dd5bc6d9fcadecdd933f2094f86bafdbe85fe"
  license "LGPL-2.1-or-later"

  # msitools doesn't seem to use the GNOME version scheme, so we have to
  # loosen the default `Gnome` strategy regex to match the latest version.
  livecheck do
    url :stable
    regex(/msitools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "791534790bcc8e23c6def007f18407258258bede405d92375d256068123b0221"
    sha256 arm64_monterey: "1738ad06a080d802f991037d76fe78069ba16e601a27ef5a2c71a65463985db0"
    sha256 arm64_big_sur:  "a8efd95e41c4b40428c1e2c6f2b3abafa76f99781d26c64cbe0ca80f27b8ab06"
    sha256 ventura:        "a2e1ead4ee47a0ec7f53106a6454e01ac6e82a9e8c5ee069e4d2515c9986a140"
    sha256 monterey:       "1539a360dda3393169191eb9e2d97822814c9d84478bf788d4a80508966b9f58"
    sha256 big_sur:        "ec00cadc6477adbd6c6b5ddd107586b31cfe8ecc78f9df7ff264c5b3b2990944"
    sha256 catalina:       "f757655d692ef4acf1192c6fa4459a77b4480e0303589b158b862a0a1497afef"
    sha256 mojave:         "ad7526c586e2bb15a4325798af37c278448315fe4434daa6553258a00ac13cd4"
    sha256 x86_64_linux:   "c2113c131d937a5d93c81c7f0a1cb8b301bae73353e986b048ccfd45c525e811"
  end

  depends_on "bison" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgsf"
  depends_on "vala"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=true", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    # wixl-heat: make an xml fragment
    assert_match "<Fragment>", pipe_output("#{bin}/wixl-heat --prefix test")

    # wixl: build two installers
    1.upto(2) do |i|
      (testpath/"test#{i}.txt").write "abc"
      (testpath/"installer#{i}.wxs").write <<~EOS
        <?xml version="1.0"?>
        <Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
           <Product Id="*" UpgradeCode="DADAA9FC-54F7-4977-9EA1-8BDF6DC73C7#{i}"
                    Name="Test" Version="1.0.0" Manufacturer="BigCo" Language="1033">
              <Package InstallerVersion="200" Compressed="yes" Comments="Windows Installer Package"/>
              <Media Id="1" Cabinet="product.cab" EmbedCab="yes"/>

              <Directory Id="TARGETDIR" Name="SourceDir">
                 <Directory Id="ProgramFilesFolder">
                    <Directory Id="INSTALLDIR" Name="test">
                       <Component Id="ApplicationFiles" Guid="52028951-5A2A-4FB6-B8B2-73EF49B320F#{i}">
                          <File Id="ApplicationFile1" Source="test#{i}.txt"/>
                       </Component>
                    </Directory>
                 </Directory>
              </Directory>

              <Feature Id="DefaultFeature" Level="1">
                 <ComponentRef Id="ApplicationFiles"/>
              </Feature>
           </Product>
        </Wix>
      EOS
      system "#{bin}/wixl", "-o", "installer#{i}.msi", "installer#{i}.wxs"
      assert_predicate testpath/"installer#{i}.msi", :exist?
    end

    # msidiff: diff two installers
    lines = `#{bin}/msidiff --list installer1.msi installer2.msi 2>/dev/null`.split("\n")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal "-Program Files/test/test1.txt", lines[-2]
    assert_equal "+Program Files/test/test2.txt", lines[-1]

    # msiinfo: show info for an installer
    out = `#{bin}/msiinfo suminfo installer1.msi`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match(/Author: BigCo/, out)

    # msiextract: extract files from an installer
    mkdir "files"
    system "#{bin}/msiextract", "--directory", "files", "installer1.msi"
    assert_equal (testpath/"test1.txt").read,
                 (testpath/"files/Program Files/test/test1.txt").read

    # msidump: dump tables from an installer
    mkdir "idt"
    system "#{bin}/msidump", "--directory", "idt", "installer1.msi"
    assert_predicate testpath/"idt/File.idt", :exist?

    # msibuild: replace a table in an installer
    system "#{bin}/msibuild", "installer1.msi", "-i", "idt/File.idt"
  end
end
