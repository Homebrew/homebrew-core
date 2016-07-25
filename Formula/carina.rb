class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.4.0",
        :revision => "f63790db44677584dc2639f42c7527626039f490"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5355dc0fc7e0d647d8ed7a6310d9407f96646c47dde1c78e5530e4501f5a1ce" => :el_capitan
    sha256 "92e9e6b093d76ef440fb5b258c38c4a590dfbc47fb2536601df077c26b856bd3" => :yosemite
    sha256 "13bd8c316df9c401f76893ab397c7681489bd81667c2861edde1f17d93d8c378" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    carinapath = buildpath/"src/github.com/getcarina/carina"
    carinapath.install Dir["{*,.git}"]

    cd carinapath do
      system "make", "get-deps"
      system "make", "carina", "VERSION=#{version}"
      bin.install "carina"
    end
  end

  test do
    system "#{bin}/carina", "--version"
  end
end
