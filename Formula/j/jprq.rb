class Jprq < Formula
    desc "Join Public Router, Quickly"
    homepage "https://jprq.io/"
    url "https://github.com/azimjohn/jprq/archive/refs/tags/2.1.tar.gz"
    sha256 "820a8509be252d4ca90eca1177e77f83f369332060661f53917d65aa65987888"
    license "MIT"
    depends_on "go" => :build
  
    def install
      system "go", "build", *std_go_args(ldflags: "-s -w"), "cli"
    end
  
    test do
      system "false"
    end
  end
  