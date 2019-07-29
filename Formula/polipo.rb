class Polipo < Formula
  desc "Web caching proxy"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/polipo/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz"
  sha256 "a259750793ab79c491d05fcee5a917faf7d9030fb5d15e05b3704e9c9e4ee015"
  head "https://github.com/jech/polipo.git"

  bottle do
    rebuild 2
    sha256 "2653a1ffd719d82318a04fd94b8a2573714c03e974b43ae7b3df6ad4b9e410f3" => :mojave
    sha256 "6fe78288ca28698ac07fd96d99fbbf311a6b410eb7150dfac5388564b76d4195" => :high_sierra
    sha256 "7a943f9e9952d78c692d5ec155b407319181a6a66ee1367801f77da8f7bb8459" => :sierra
  end

  def install
    cache_root = (var + "cache/polipo")
    cache_root.mkpath

    args = %W[
      PREFIX=#{prefix}
      LOCAL_ROOT=#{pkgshare}/www
      DISK_CACHE_ROOT=#{cache_root}
      MANDIR=#{man}
      INFODIR=#{info}
      PLATFORM_DEFINES=-DHAVE_IPv6
    ]

    system "make", "all", *args
    system "make", "install", *args
  end

  plist_options :manual => "polipo"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/polipo</string>
        </array>
        <!-- Set `ulimit -n 65536`. The default macOS limit is 256, that's
             not enough for Polipo (displays 'too many files open' errors).
             It seems like you have no reason to lower this limit
             (and unlikely will want to raise it). -->
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>65536</integer>
        </dict>
      </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec "#{bin}/polipo"
    end
    sleep 2

    begin
      output = shell_output("curl -s http://localhost:8123")
      assert_match "<title>Welcome to Polipo</title>", output, "Polipo webserver did not start!"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
