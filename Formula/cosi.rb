require "language/go"

class Cosi < Formula
  desc "Implementation of scalable collective signing"
  homepage "https://github.com/dedis/cosi"
  url "https://github.com/dedis/cosi/archive/0.8.5.tar.gz"
  sha256 "7dd25c83a838ebadff3c8f6b8a5bd84702cf74e5e6eb545359b7816f89b85e73"

  bottle do
    cellar :any_skip_relocation
    sha256 "f368b353b76109a1ef3d4f3859bbac2179bf09bb8ce8a7d349a816d12e9fa298" => :mojave
    sha256 "91a07519054c07be10182099d75adf74d017a74053d14985653e272ec1238fff" => :high_sierra
    sha256 "b387fbd7aa15c4348e56fd1e28adbabee656cd142c979ea556e2d5e8dc56d4b1" => :sierra
    sha256 "e73fd1b11e66d3931c91d6504b9958d44059aa4f3bbc547ed6cc8bdbc3717c6e" => :el_capitan
    sha256 "2953f8c62a93c976bf450d9605cab850d6d442e9e1885f3a455243942e59f6dd" => :yosemite
    sha256 "73d73bd817f6700c751a9065133ea460115ee5e5dbbff89d0655137bee30ef1f" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "f0aeabca5a127c4078abb8c8d64298b147264b55"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "511bcaf42ccd42c38aba7427b6673277bf19e2a1"
  end

  go_resource "github.com/dedis/crypto" do
    url "https://github.com/dedis/crypto.git",
        :revision => "d9272cb478c0942e1d60049e6df219cba2067fcd"
  end

  go_resource "github.com/dedis/protobuf" do
    url "https://github.com/dedis/protobuf.git",
        :revision => "6948fbd96a0f1e4e96582003261cf647dc66c831"
  end

  go_resource "github.com/montanaflynn/stats" do
    url "https://github.com/montanaflynn/stats.git",
        :revision => "60dcacf48f43d6dd654d0ed94120ff5806c5ca5c"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "f9ab0dce87d815821e221626b772e3475a0d2749"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "0c607074acd38c5f23d1344dfe74c977464d1257"
  end

  go_resource "gopkg.in/codegangsta/cli.v1" do
    url "https://gopkg.in/codegangsta/cli.v1.git",
        :revision => "01857ac33766ce0c93856370626f9799281c14f4"
  end

  go_resource "gopkg.in/dedis/cothority.v0" do
    url "https://gopkg.in/dedis/cothority.v0.git",
        :revision => "e5eb384290e5fd98b8cb150a1348661aa2d49e2a"
  end

  def install
    mkdir_p buildpath/"src/github.com/dedis"
    ln_s buildpath, buildpath/"src/github.com/dedis/cosi"

    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "cosi"
    prefix.install "dedis_group.toml"
    bin.install "cosi"
  end

  test do
    (testpath/"config.toml").write <<~EOS
      Public = "7b6d6361686d0c76d9f4b40961736eb5d0849f7db3f8bfd8f869b8015d831d45"
      Private = "01a80f4fef21db2aea18e5288fe9aa71324a8ad202609139e5cfffc4ffdc4484"
      Addresses = ["0.0.0.0:6879"]
    EOS
    (testpath/"group.toml").write <<~EOS
      [[servers]]
        Addresses = ["127.0.0.1:6879"]
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
