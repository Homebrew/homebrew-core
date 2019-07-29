class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"
  revision 1

  bottle do
    sha256 "e9a0967af35772fecd4908ed2a8f5476def47e8f278b40f88f1e92d3a67cfc3d" => :mojave
    sha256 "4ca7c20ef94d78dcfb93241855c10be2113f538eae93e0a31702049a4d95e825" => :high_sierra
    sha256 "4ca7c20ef94d78dcfb93241855c10be2113f538eae93e0a31702049a4d95e825" => :sierra
    sha256 "4ca7c20ef94d78dcfb93241855c10be2113f538eae93e0a31702049a4d95e825" => :el_capitan
  end

  depends_on "docbook2x" => :build
  depends_on "python"

  def install
    inreplace "pastebinit" do |s|
      s.gsub! "/usr/bin/python3", Formula["python"].opt_bin/"python3"
      s.gsub! "/usr/local/etc/pastebin.d", etc/"pastebin.d"
    end

    system "docbook2man", "pastebinit.xml"
    bin.install "pastebinit"
    etc.install "pastebin.d"
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    libexec.install %w[po utils]
  end

  test do
    url = pipe_output("#{bin}/pastebinit -a test -b paste.ubuntu.com", "Hello, world!").chomp
    assert_match "://paste.ubuntu.com/", url
  end
end
