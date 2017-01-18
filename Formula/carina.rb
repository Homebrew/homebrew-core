class Carina < Formula
  desc "command-line client for Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v2.0.1",
        :revision => "15e3e772a56553e563598288be720c703c4166e6"
  head "https://github.com/getcarina/carina.git"

  bottle do
    sha256 "0b90a3e277e586074d876c5d84d800640ba273f0cc6e9fb776e0507bafcade9b" => :sierra
    sha256 "04b201c2952c6d81aee9885285530f8a8e19be332de266443df542ada48062ae" => :el_capitan
    sha256 "0fa4c677d1055496b02c11beb2fec16604f8daf4b87d5e204205825790ac4d81" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    carinapath = buildpath/"src/github.com/getcarina/carina"
    carinapath.install Dir["{*,.git}"]

    cd carinapath do
      system "make", "get-deps"
      system "make", "local", "VERSION=#{version}"
      bin.install "carina"
    end
  end

  test do
    system "#{bin}/carina", "--version"
  end
end
