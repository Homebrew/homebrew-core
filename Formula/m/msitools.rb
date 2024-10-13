class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.103/msitools-0.103.tar.xz"
  sha256 "d17622eebbf37fa4c09b59be0bc8db08b26be300a6731c74da1ebce262bce839"
  license "LGPL-2.1-or-later"

  # msitools doesn't seem to use the GNOME version scheme, so we have to
  # loosen the default `Gnome` strategy regex to match the latest version.
  livecheck do
    url :stable
    regex(/msitools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "68e661be46cc7452fe15b99dc90f3cbe572d7cf644fd399707c7313dc3bcb52b"
    sha256 arm64_sonoma:   "ee10c9cb4bc12d8b4576418734817953546f1aaae34b94b1aa19fa0649159bdf"
    sha256 arm64_ventura:  "01b5cc782019274ccbad9e4afe6c5a27cc2e109dfa6bfb7ee143fd09a63a38a6"
    sha256 arm64_monterey: "5a6840a0a0b3c0e54e55ef878605137f4eb4e2c1082ca7ba62bc02b484fdea2e"
    sha256 arm64_big_sur:  "76e21c30adc03a9a4cb84106f51b3c54d31c9f326b2d9222f3e35adbf186a401"
    sha256 sonoma:         "cb728cc524057356ccb7d6cd0af3c60e029e7b49398909c0a48f1d5764926fa8"
    sha256 ventura:        "62b2ae934d45e550a1cbe0ba9ac658e5e0fba3dded31ef04f98c8d903918291e"
    sha256 monterey:       "e7439f8b6c48cd20c91511bd38c9c9865f82eb2b6523f77c3f5c529f0e1ee240"
    sha256 big_sur:        "9b37bccc09e4ab2bf6bb43c43091200a88f5718041ac90b51cb71b76decbdf68"
    sha256 x86_64_linux:   "093a2c2b753afb2114b81cca5af13e414ce77b11e0ba1a0b3a9c8d913f6a523c"
  end

  depends_on "bison" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gcab"
  depends_on "glib"
  depends_on "libgsf"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dintrospection=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
      system bin/"wixl", "-o", "installer#{i}.msi", "installer#{i}.wxs"
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
    system bin/"msiextract", "--directory", "files", "installer1.msi"
    assert_equal (testpath/"test1.txt").read,
                 (testpath/"files/Program Files/test/test1.txt").read

    # msidump: dump tables from an installer
    mkdir "idt"
    system bin/"msidump", "--directory", "idt", "installer1.msi"
    assert_predicate testpath/"idt/File.idt", :exist?

    # msibuild: replace a table in an installer
    system bin/"msibuild", "installer1.msi", "-i", "idt/File.idt"
  end
end
