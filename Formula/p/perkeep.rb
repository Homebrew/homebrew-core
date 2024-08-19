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
      url "https://github.com/gopherjs/gopherjs/archive/refs/tags/v1.18.0-beta2+go1.18.5.tar.gz"
      sha256 "8dc2e85245343862e47ce9293e7c4b364cbd7aada734b823366ba10e72cfb93e"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b429739bba2e8ad57ecb69c26cb2fd239c6043ab09cd1eed447cae945c4ffd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3f22417345af02864c07b3dc562ba8761cbc0ad45cd1504d7142b0ef18065f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dc4933072ef2f422c7f27eebe7a687bcee27ec38229afa5b80284b33a6ce023"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4624396d2d8f4a57c59cb8a44d7523835562839d4b588cf313d261cdd5ae1cb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8edd2f71ffd51e01410e1eb11f77d0621fb663a148fbf06b368b2fc71312575b"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7553919ace49169e83acc7356542aa62dcdcbc857a84a62e7c28ad3dd205fd"
    sha256 cellar: :any_skip_relocation, monterey:       "21c3e3e744c284d7ed0d27837599c887a69c5c3ae0ce7035f9a9f2cbffde1180"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4bbe8600fee0e1cbf39a389ba6ceefd57d787d329256aa0bd0c2edf9f8fef9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46418f4f07c4f2934642ef6c99795aa69a0d4b394f73ffe11a6625ae864c4286"
  end

  # HEAD may support Go 1.19 but last release was on 2020-11-11.
  disable! date: "2024-02-12", because: "has `gopherjs` resource that doesn't support Go 1.19 or later"

  # This should match what gopherjs supports.
  depends_on "go@1.18" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", because: "both install `hello` binaries"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      ENV["CAMLI_GOPHERJS_GOROOT"] = Formula["go@1.18"].opt_libexec

      (buildpath/"src/perkeep.org").install buildpath.children

      # Vendored version of gopherjs requires go 1.10, so use the newest available gopherjs, which
      # supports newer Go versions.
      rm_r(buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs")
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
