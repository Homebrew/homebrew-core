class Jprq < Formula
    desc "Join Public Router, Quickly"
    homepage "https://jprq.io/"
    url "https://github.com/azimjohn/jprq/archive/refs/tags/2.2.tar.gz"
    sha256 "6121e0ac74512052ed00c57c363f0f0b66910618ebd8134cfa72acca05b09163"
    license "MIT"
    depends_on "go" => :build
  
    def install
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
    end
  
    test do
      system "#{bin}/jprq", "--version"
    end
  end
  