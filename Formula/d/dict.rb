class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "https://dict.org/bin/Dict"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.3/dictd-1.13.3.tar.gz"
  sha256 "192129dfb38fa723f48a9586c79c5198fc4904fec1757176917314dd073f1171"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "17a1959eabe3baa7e124871059f0c4312498cfacceb1affbcc60f50fb2527171"
    sha256 arm64_tahoe:       "694d764e37305e78a62434292d69b0d50a2a093554ca772789ea9652e56a92e7"
    sha256 arm64_sequoia:     "07762c92a3981c4028fd215f163867bd9fe2499fbd5419ca024bc7a10d7e11d1"
    sha256 arm64_sonoma:      "030dd27736efe0640b5293f3f24d33a0b83304cbed29e158c91117be6c730a72"
    sha256 sonoma:            "c5b41893bf0b335596c40a1e7e197d872bb98a7d7d4fbbd9ee55aab4183de4f3"
    sha256 arm64_linux:       "e7efbe26bdb41e097a1a7533e9a48247e22cd4abc864654efb0382d5db9e5781"
    sha256 x86_64_linux:      "3a4ad3c79cfde170a352b43cf03440508c8be5ed6389721043a5368ff045d023"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ac_cv_search_yywrap"] = "yes"
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make"
    system "make", "install"
    (prefix/"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end

  test do
    pipe_output("#{bin}/dictfmt -j -u local -s Test test", ":homebrew:The missing package manager\n", 0)
    (testpath/"dictd.conf").write <<~EOS
      database test { data "#{testpath}/test.dict" index "#{testpath}/test.index" }
    EOS

    port = free_port
    pid = spawn sbin/"dictd", "--config", testpath/"dictd.conf", "--port", port.to_s,
                "--listen-to", "127.0.0.1", "-d", "nodetach"
    begin
      sleep 2
      assert_match "The missing package manager", shell_output("#{bin}/dict -h 127.0.0.1 -p #{port} homebrew")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
