class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.106/msitools-0.106.tar.xz"
  sha256 "1ed34279cf8080f14f1b8f10e649474125492a089912e7ca70e59dfa2e5a659b"
  license "LGPL-2.1-or-later"
  revision 1

  # msitools doesn't seem to use the GNOME version scheme, so we have to
  # loosen the default `Gnome` strategy regex to match the latest version.
  livecheck do
    url :stable
    regex(/msitools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9184769d09209b3400d048bd93277ce6cdd0402cba3dfea7737522387162080a"
    sha256 arm64_sequoia: "6c3299c0e9abfac5e3dc049380e2affab3504bbe00f397009165ceab06e96be5"
    sha256 arm64_sonoma:  "82abccc8bfde0251209cb2aaa6f9de5d00a36d53a00ca49367408b306320d71e"
    sha256 sonoma:        "26e11c16e3bc190016c67cd0f92e28e6602ee7ae4b27b1f50521a151220aff68"
    sha256 arm64_linux:   "197a202f269b1c6afbefc10e748e3ef6ae8f33c85831d7baf0b2350ae3b808b8"
    sha256 x86_64_linux:  "20b6f97f44977fe47f6f56d2a58bb7fb1575fdce52855c03e0dfdfa41575e500"
  end

  depends_on "bison" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    assert_match "<Fragment>", pipe_output("#{bin}/wixl-heat --prefix test", nil, 0)

    # wixl: build two installers
    1.upto(2) do |i|
      (testpath/"test#{i}.txt").write "abc"
      (testpath/"installer#{i}.wxs").write <<~XML
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
      XML
      system bin/"wixl", "-o", "installer#{i}.msi", "installer#{i}.wxs"
      assert_path_exists testpath/"installer#{i}.msi"
    end

    # msidiff: diff two installers
    lines = shell_output("#{bin}/msidiff --list installer1.msi installer2.msi 2>/dev/null").split("\n")
    assert_equal "-Program Files/test/test1.txt", lines[-2]
    assert_equal "+Program Files/test/test2.txt", lines[-1]

    # msiinfo: show info for an installer
    out = shell_output("#{bin}/msiinfo suminfo installer1.msi")
    assert_match(/Author: BigCo/, out)

    # msiextract: extract files from an installer
    mkdir "files"
    system bin/"msiextract", "--directory", "files", "installer1.msi"
    assert_equal (testpath/"test1.txt").read,
                 (testpath/"files/Program Files/test/test1.txt").read

    # msidump: dump tables from an installer
    mkdir "idt"
    system bin/"msidump", "--directory", "idt", "installer1.msi"
    assert_path_exists testpath/"idt/File.idt"

    # msibuild: replace a table in an installer
    system bin/"msibuild", "installer1.msi", "-i", "idt/File.idt"
  end
end
