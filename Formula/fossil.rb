class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.9.tar.gz"
  sha256 "1cb2ada92d43e3e7e008fe77f5e743d301c7ea34d4c36c42f255f873e73d8b4f"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "26824c9aabd17ee21379354468d70e5fee77d0e209257c6a9814c877ec2ebfbb" => :mojave
    sha256 "4e12d6e813f147a034f2a5a08a9d36e744531a83cfd8195850ca492e40e98925" => :high_sierra
    sha256 "31eccca72e7ca53b48b66ecedcd883a50af41e1f355a34ae229f39fe79120632" => :sierra
  end

  depends_on "openssl"
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
