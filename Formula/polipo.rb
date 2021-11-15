class Polipo < Formula
  desc "Web caching proxy"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/polipo/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz"
  sha256 "a259750793ab79c491d05fcee5a917faf7d9030fb5d15e05b3704e9c9e4ee015"
  license "MIT"
  head "https://github.com/jech/polipo.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_monterey: "34d7d132bc2ede1d1aaa11888f5ac25cdb7a4be4b0c1587066f5a4d60d39da86"
    sha256 arm64_big_sur:  "9e881c585217cd8354877025690bf3f35c2e036ef6c3b46dd1005c505b4e3984"
    sha256 monterey:       "3623285c43504bc8b3d6fbb2c469a64dbba1b22ba08ff8bfb1a9ec1253cadc23"
    sha256 big_sur:        "3e847b380dc3c582beb070ff92b03182d4d50bc38bc74c210365111b8cec04fa"
    sha256 catalina:       "c1806514cf77c3b9738131299f04a2c051617a3a44cd1aa4440ecd16103c5bad"
    sha256 mojave:         "2653a1ffd719d82318a04fd94b8a2573714c03e974b43ae7b3df6ad4b9e410f3"
    sha256 high_sierra:    "6fe78288ca28698ac07fd96d99fbbf311a6b410eb7150dfac5388564b76d4195"
    sha256 sierra:         "7a943f9e9952d78c692d5ec155b407319181a6a66ee1367801f77da8f7bb8459"
    sha256 x86_64_linux:   "6550ead1811229d39fc09b0be00d1f0798aff40eb0a57fff9b6a0bd937e3514a"
  end

  # https://github.com/jech/polipo/commit/4d42ca1b5849518762d110f34b6ce2e03d6df9ec
  deprecate! date: "2016-11-06", because: :unsupported

  uses_from_macos "texinfo"

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

  service do
    run [opt_bin/"polipo"]
    keep_alive true
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
