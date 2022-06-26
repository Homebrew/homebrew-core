class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/perkeep/perkeep.git", branch: "master"

  stable do
    url "https://github.com/perkeep/perkeep.git",
        tag:      "0.11",
        revision: "76755286451a1b08e2356f549574be3eea0185e5"

    # Newer gopherjs to support a newer Go version.
    resource "gopherjs" do
      url "https://github.com/gopherjs/gopherjs/archive/refs/tags/1.17.1+go1.17.3.tar.gz"
      sha256 "8c5275ddf09646fdeb9df701f49425feb2327ec25dddfa49e2d9d323813398af"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80b74aa6f9784371b2a2b4f79ed15fb8d998a3589f1cc85885ba60d259196dea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b02cb9968771e49d46b9f605d53f88b61bb32cd765d46146280b2426abffc00f"
    sha256 cellar: :any_skip_relocation, monterey:       "a30e484cd077d745047fcf919d857ed2d1ca68589b7017e91e0417fa5c256b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "663b51444cae568b049afdc4c3bffb0dadd70dc0d63764cf6a9e9d9f5568afc1"
    sha256 cellar: :any_skip_relocation, catalina:       "6ccd732cc142a7efb8b78b150909eb0eabde2d9fbb9683fdfaaf550c2ebbbbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3822eb5d2bc22fb31733101ca980db8baf8ebc4ab1994a47fc0739ab35a998d"
  end

  # This should match what gopherjs supports.
  depends_on "go@1.17" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", because: "both install `hello` binaries"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      ENV["CAMLI_GOPHERJS_GOROOT"] = Formula["go"].opt_libexec

      (buildpath/"src/perkeep.org").install buildpath.children

      # Vendored version of gopherjs requires go 1.10, so use the newest available gopherjs, which
      # supports newer Go versions.
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
