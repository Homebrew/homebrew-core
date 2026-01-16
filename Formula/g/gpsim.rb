class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.32.0/gpsim-0.32.1.tar.gz"
  sha256 "c704d923ae771fabb7f63775a564dfefd7018a79c914671c4477854420b32e69"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/gpsim[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "eaff4cd77c4e03aff25bc78d8a4a817ddd1772bb4f11f6af22f55bea64b1e1f2"
    sha256 cellar: :any,                 arm64_sequoia:  "0e00390c7ead8acdb2ecffe0c1181c0fdd1fbaa325cd50304c98652e61c2e15a"
    sha256 cellar: :any,                 arm64_sonoma:   "888ef0d3830e09344fe6f4851d2df34a9793dc3de9178e1d2dc99451fa612fde"
    sha256 cellar: :any,                 arm64_ventura:  "fcfd3aa9b7bbfd39292005f97e046513efb63f5f35723ed28d846fe63969c596"
    sha256 cellar: :any,                 arm64_monterey: "7d7bdb973048a0accf1f87f5773883e80cb98a3e80ec3e6a2ae2240f06b4f8d9"
    sha256 cellar: :any,                 sonoma:         "e04f087424cabf6638050b7a4a477184ab1814a8d08116f6fe4bd997fb98e174"
    sha256 cellar: :any,                 ventura:        "21b9949b633afe932ca30e23cc291a8a6d760cb38413f1728b4f8e7b1349f10c"
    sha256 cellar: :any,                 monterey:       "cd3488cd018dfaefdd5b4e253b6e6879c9a75ef1e6c377dc7928daf20825c882"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5d4298f5d3c0594f96b60229ffaa2c6fb118749928a7bf04f985bea81a6d5c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062b82cfd0c548f5935b7f09f455d56a0fcc9693f044c553dc161233d89add2a"
  end

  depends_on "gputils" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"
  depends_on "readline"

  # https://sourceforge.net/p/gpsim/bugs/289/
  patch :DATA

  def install
    system "./configure", "--disable-gui",
                          "--disable-shared",
                          *std_configure_args
    system "make", "all"
    system "make", "install"
  end

  test do
    system bin/"gpsim", "--version"
  end
end

__END__
Index: program_files.cc
===================================================================
--- a/src/program_files.cc  (revision 2623)
+++ b/src/program_files.cc  (working copy)
@@ -85,8 +85,7 @@
   * ProgramFileTypeList
   * Singleton class to manage the many (as of now three) file types.
   */
-ProgramFileTypeList * ProgramFileTypeList::s_ProgramFileTypeList =
-  new ProgramFileTypeList();
+ProgramFileTypeList * ProgramFileTypeList::s_ProgramFileTypeList = nullptr;
 // We will instantiate g_HexFileType and g_CodFileType here to be sure
 // they are instantiated after s_ProgramFileTypeList. The objects will
 // move should the PIC code moved to its own external module.
@@ -97,6 +96,8 @@
 
 ProgramFileTypeList &ProgramFileTypeList::GetList()
 {
+  if (!s_ProgramFileTypeList)
+      s_ProgramFileTypeList = new ProgramFileTypeList();
   return *s_ProgramFileTypeList;
 }
