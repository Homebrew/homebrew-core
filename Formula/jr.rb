class Jr < Formula
    desc "Quality Random Data from the Command-line"
    homepage "https://github.com/ugol/jr"
    url "https://github.com/ugol/jr/archive/refs/tags/v0.2.1.tar.gz"
    sha256 "d150ae875c9238e3d23b06bd069f0d03855f0b6763b3b6b3eb8b89d2dfc02cae"
    license "MIT"
  
    depends_on "go" => :build
  
    def install
      system "make", "all"
      bin.install Dir["build/*"]
      prefix.install "templates"
    end
  
    test do
      system "#{bin}/jr"
    end
  end
  