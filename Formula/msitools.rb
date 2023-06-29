class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.102/msitools-0.102.tar.xz"
  sha256 "fa485a421397ef5fe02df5ab93fced91abf685730f40f94c7157b430d24a3498"
  license "LGPL-2.1-or-later"

  # msitools doesn't seem to use the GNOME version scheme, so we have to
  # loosen the default `Gnome` strategy regex to match the latest version.
  livecheck do
    url :stable
    regex(/msitools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "254724502ed0fc447da977b7947939a1ad6931896880aeb8c121d56472fdd979"
    sha256 arm64_monterey: "aeedbe7f0bf230e6f77223076b7f1ab06b3423f40711b90f197899ee274ca536"
    sha256 arm64_big_sur:  "0f1fb016d9a6df1075a73f294f5ca2ec439bdef3fa1d999f735e8ad1c2ec100b"
    sha256 ventura:        "cc726522014040dcb845efd71a01dca91e1af7f4384a9caef247e9a6c7b8d20f"
    sha256 monterey:       "e4588b75cc3c4b3da4969d57f18d1179793ee8ed59859da9dabe3a3d3c225537"
    sha256 big_sur:        "f80ca9cabf98a1945e306634d884e233f1935ab05bd6ab8755a14e1966d3ac88"
    sha256 x86_64_linux:   "aee2f1fcb159b1984db307153ba19a31b28c4e3fbba05857befe06e5b0b46e7c"
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
