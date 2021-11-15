require "language/go"

class Cosi < Formula
  desc "Implementation of scalable collective signing"
  homepage "https://github.com/dedis/cosi"
  url "https://github.com/dedis/cosi/archive/0.8.6.tar.gz"
  sha256 "007e4c4def13fcecf7301d86f177f098c583151c8a3d940ccb4c65a84413a9eb"
  license "AGPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80018e20758565f4559b3b6b1477e7b4d8f6654206056d727dcee2d3196b69ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b529b010f6c26cb971f84630f3fdf1fcf185991d7606e5eeee985d086cc7e33"
    sha256 cellar: :any_skip_relocation, monterey:       "545693cdefb146ce05e92a289ab373fca3eccaaf064f078d842b1c0db87a19e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "80422d33e38e99d9d70958a4b8edfcae2e740e5392b4b5d32ead4a4d2abf1b99"
    sha256 cellar: :any_skip_relocation, catalina:       "30bbb457c0fb67ee264331e434068a4a747ece4cbc536cb75d289a06e93988e2"
    sha256 cellar: :any_skip_relocation, mojave:         "2ddd695441977b1cd435fbae28d9aa864d48b7a90ec24971348d91b5d0e551df"
    sha256 cellar: :any_skip_relocation, high_sierra:    "00663999a04ee29f52e334022cc828d7ebe89a442f1e713afb2167112f4ebf75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0af35c14fbdff8b9ddf46a325903d87fd3d5e7c4d7ea6d26ba2d4c8c4ac8201"
  end

  # Deprecated in favor of the Cothority `blcosi` package.
  # See: https://github.com/dedis/cothority/tree/master/cosi
  deprecate! date: "2018-03-01", because: :deprecated_upstream

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        revision: "f0aeabca5a127c4078abb8c8d64298b147264b55"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        revision: "511bcaf42ccd42c38aba7427b6673277bf19e2a1"
  end

  go_resource "github.com/dedis/crypto" do
    url "https://github.com/dedis/crypto.git",
        revision: "d9272cb478c0942e1d60049e6df219cba2067fcd"
  end

  go_resource "github.com/dedis/protobuf" do
    url "https://github.com/dedis/protobuf.git",
        revision: "6948fbd96a0f1e4e96582003261cf647dc66c831"
  end

  go_resource "github.com/montanaflynn/stats" do
    url "https://github.com/montanaflynn/stats.git",
        revision: "60dcacf48f43d6dd654d0ed94120ff5806c5ca5c"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        revision: "f9ab0dce87d815821e221626b772e3475a0d2749"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        revision: "0c607074acd38c5f23d1344dfe74c977464d1257"
  end

  go_resource "gopkg.in/codegangsta/cli.v1" do
    url "https://gopkg.in/codegangsta/cli.v1.git",
        revision: "01857ac33766ce0c93856370626f9799281c14f4"
  end

  go_resource "gopkg.in/dedis/cothority.v0" do
    url "https://gopkg.in/dedis/cothority.v0.git",
        revision: "e5eb384290e5fd98b8cb150a1348661aa2d49e2a"
  end

  def install
    mkdir_p buildpath/"src/github.com/dedis"
    ln_s buildpath, buildpath/"src/github.com/dedis/cosi"

    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"
    ENV["GO111MODULE"] = "auto"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "cosi"
    prefix.install "dedis_group.toml"
    bin.install "cosi"
  end

  test do
    port = free_port
    (testpath/"config.toml").write <<~EOS
      Public = "7b6d6361686d0c76d9f4b40961736eb5d0849f7db3f8bfd8f869b8015d831d45"
      Private = "01a80f4fef21db2aea18e5288fe9aa71324a8ad202609139e5cfffc4ffdc4484"
      Addresses = ["0.0.0.0:#{port}"]
    EOS
    (testpath/"group.toml").write <<~EOS
      [[servers]]
        Addresses = ["127.0.0.1:#{port}"]
        Public = "e21jYWhtDHbZ9LQJYXNutdCEn32z+L/Y+Gm4AV2DHUU="
    EOS
    begin
      file = prefix/"README.md"
      sig = "README.sig"
      pid = fork { exec bin/"cosi", "server", "-config", "config.toml" }
      sleep 2
      assert_match "Success", shell_output("#{bin}/cosi check -g group.toml")
      system bin/"cosi", "sign", "-g", "group.toml", "-o", sig, file
      out = shell_output("#{bin}/cosi verify -g group.toml -s #{sig} #{file}")
      assert_match "OK", out
    ensure
      Process.kill("TERM", pid)
    end
  end
end
