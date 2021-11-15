class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  license "Apache-2.0"
  head "https://github.com/perkeep/perkeep.git", branch: "master"

  stable do
    url "https://github.com/perkeep/perkeep.git",
        tag:      "0.11",
        revision: "76755286451a1b08e2356f549574be3eea0185e5"

    # gopherjs doesn't tag releases, so just pick the most recent revision for now
    resource "gopherjs" do
      url "https://github.com/gopherjs/gopherjs/archive/fce0ec30dd00773d3fa974351d04ce2737b5c4d9.tar.gz"
      sha256 "e5e6ede5f710fde77e48aa1f6a9b75f5afeb1163223949f76c1300ae44263b84"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb070655d3eb90155a51c54d327108fc21fa80843d07dd9ab8302d75f31928a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9df8643ff9e18a35f5c36e7ad3f894ac9c1ca6ec005964d0d7d67e7f1df34c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "86a30148823155af535d6bdae10b265cdaf5b499ed38985bb0a988f19ff67718"
    sha256 cellar: :any_skip_relocation, big_sur:        "893d6cfc23b18401987de13cb5630bb259f9d3d4d0de56ebaa7d2f3f7e93333a"
    sha256 cellar: :any_skip_relocation, catalina:       "c676479c6b5f7e5bbee45c7b0d31b26c05915195c2ab7b61156ac46257b14cb6"
    sha256 cellar: :any_skip_relocation, mojave:         "e05528f7efbb84fa9bbb39a68f3d0bb48073806a204eba8d0f70a52871ed83fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec90f3dab9f58090d10ab37c5043d98832493e60af73794cc668584c6fe5c524"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", because: "both install `hello` binaries"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      ENV["CAMLI_GOPHERJS_GOROOT"] = Formula["go@1.12"].opt_libexec

      (buildpath/"src/perkeep.org").install buildpath.children

      # Vendored version of gopherjs requires go 1.10, so use the newest available gopherjs, which
      # supports up to go 1.12
      rm_rf buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"
      resource("gopherjs").stage buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"

      cd "src/perkeep.org" do
        system "go", "run", "make.go"
      end

      bin.install Dir["bin/*"].select { |f| File.executable? f }
    else
      system "go", "run", "make.go"
      bin.install Dir[".brew_home/go/bin/*"].select { |f| File.executable? f }
    end
  end

  service do
    run [opt_bin/"perkeepd", "-openbrowser=false"]
    keep_alive true
  end

  test do
    system bin/"pk-get", "-version"
  end
end
