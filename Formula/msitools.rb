class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.99/msitools-0.99.tar.xz"
  sha256 "d475939a5e336b205eb3137bac733de8099bc74829040e065b01b15f6c8b3635"

  bottle do
    sha256 "919a699e30ed3416a101c9b6488691a5a6ad64a1dd1565579a3c4345fd8d456a" => :catalina
    sha256 "d99f819451f9ce0ae4906dd096cb9db8384e2ab0f273ab81ab834af10d109bf8" => :mojave
    sha256 "afa0c094ff3c227302213e0e875c17510b48c5b90a9e317b94198140771a42d8" => :high_sierra
    sha256 "633b5a43c4c0517c0c1fb58661049e6987c4d3c9b82035394282d20278aa3015" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgsf"
  depends_on "vala"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # wixl-heat: make an xml fragment
    assert_match /<Fragment>/, pipe_output("#{bin}/wixl-heat --prefix test")

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
    assert_match /Author: BigCo/, out

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
