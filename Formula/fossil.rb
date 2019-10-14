class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.9.tar.gz"
  sha256 "1cb2ada92d43e3e7e008fe77f5e743d301c7ea34d4c36c42f255f873e73d8b4f"
  revision 1
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "9477508505b77e23d3e20387141b1dd98ea384b768283bec8f3b4ae161220e6a" => :catalina
    sha256 "c876f19f2fe8bd1d92360437baee0e3887a7598497328f408b5ad84d5ffe6696" => :mojave
    sha256 "8b3b9b01b25196cef89e25e95b0eda93976a43fc3f525f77cc4353e492142091" => :high_sierra
    sha256 "52de169a2cc7dcf4eff56e9553184f1790f98ee1bd21b367aeb83d1c637c862e" => :sierra
  end

  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    if MacOS.sdk_path_if_needed
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      args << "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
