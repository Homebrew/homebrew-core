class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"
  license "GPL-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90c20fef3e5c3e0944fadf42e45692288edb5e5ee241a4d936fe509c2e8ec16d"
    sha256 cellar: :any_skip_relocation, big_sur:       "43c42eb708a8452001802163a22e637ff7685c1e9fbd72b58102a68ccdffaf52"
    sha256 cellar: :any_skip_relocation, catalina:      "f24d4dbd9723f5726c7786af82cd16df86485ea3ae075906531f82d0544ec688"
    sha256 cellar: :any_skip_relocation, mojave:        "d2195934de64bf7814790b59d2429b90cb58e492f13f08430958b82ec3bd652d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4ca0432c7652ab49ee0f61823335d0e0ea70caaf220f4654291406dcb425cd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4f082edf6ea33925ff9fdfd0293fccc48364e649dde09731348a099c1732fc"
  end

  depends_on "docbook2x" => :build
  depends_on "python@3.9"

  # Remove for next release
  patch do
    url "https://github.com/lubuntu-team/pastebinit/commit/ab05aa431a6bf76b28586ad97c98069b8de5e46a.patch?full_index=1"
    sha256 "1abd0ec274cf0952a371e6738fcd3ece67bb9a4dd52f997296cd107f035f5690"
  end

  def install
    inreplace "pastebinit" do |s|
      s.gsub! "/usr/bin/python3", Formula["python@3.9"].opt_bin/"python3"
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
