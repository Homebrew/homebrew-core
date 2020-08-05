class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.100/msitools-0.100.tar.xz"
  sha256 "bbf1a6e3a9c2323b860a3227ac176736a3eafc4a44a67346c6844591f10978ea"

  bottle do
    sha256 "f9b65f68c973c323e96a0492df562bae32e3ede79d9e5a6f24b89f53ef085883" => :catalina
    sha256 "b7646423954ae62a8dcb8ee413f98e0f5e1c4b8a73876255fcd2f0371e547f92" => :mojave
    sha256 "fd8689ba0902ed4d784f85969d281a0e1c58bb76f0fe17a93d96ba2d3f845cdb" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgsf"
  depends_on "vala"

  # Workaround for https://gitlab.gnome.org/GNOME/msitools/issues/15
  # Merged upstream in the following commits:
  # https://gitlab.gnome.org/GNOME/msitools/commit/248450a2f2a23df59428fa816865a26f7e2496e0
  # https://gitlab.gnome.org/GNOME/msitools/commit/9bbcc6da06ccf6144258c26ddcaab3262538d3ce
  # Remove in next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/msitools/commit/248450a2f2a23df59428fa816865a26f7e2496e0.diff"
    sha256 "5046316e61af8af32a2b7d4ed2579a88fe0618e56d0aca32fea2c8a64b747f06"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/msitools/commit/9bbcc6da06ccf6144258c26ddcaab3262538d3ce.diff"
    sha256 "fadc1c5ade1afd8add5f5a4997a10098efa9f24a5788230a16af89965551c1c7"
  end

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
