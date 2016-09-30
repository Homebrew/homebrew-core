class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"

  bottle do
    cellar :any_skip_relocation
    sha256 "71974010132dbde6fe65cd12ef87e6f3374b66f4710cbea49eda848847bf150c" => :sierra
    sha256 "c4ba9f88e6fad1b21fb2b433adf16855086063c143df0b10aea669dce3df189a" => :el_capitan
    sha256 "42f4b20a8f4361de3f03077bda5c2ecdac87759723ac383b562f0c21b8791d93" => :yosemite
    sha256 "628ce64e3127dff93a92aa08019ad7c191f0b285dc8ed8cc2248c09d72abc5f5" => :mavericks
  end

  depends_on "docbook2x" => :build
  depends_on "python3"

  def install
    inreplace "pastebinit" do |s|
      s.gsub! "/usr/bin/python3", Formula["python3"].opt_bin/"python3"
      s.gsub! "/usr/local/etc/pastebin.d", etc/"pastebin.d"
    end

    system "docbook2man", "pastebinit.xml"
    bin.install "pastebinit"
    etc.install "pastebin.d"
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    libexec.install %w[po utils]
  end

  test do
    url = pipe_output("#{bin}/pastebinit", "Hello, world!").chomp
    assert_match "http://pastebin.com/", url
    # We can't actually fetch the URL to check the paste's success because
    # pastebin blocks our fetches with curl, probably based on the user agent.
  end
end
