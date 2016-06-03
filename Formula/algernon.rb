require "language/go"

class Algernon < Formula
  desc "HTTP/2 web server with built-in support for Lua and templates"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.0.tar.gz"
  sha256 "b7f169f1d00057d152a2ff376b4e2fdac2bc0cf37003cc9cf77ad69afd3d056d"
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "b8ea8fd8bcdb5b81df88d79e8a16f931f90b6b9a0c4a3221d288ad77876cb689" => :el_capitan
    sha256 "16918d822d182c48e4ea852a2146419fa33a5a067fd63b2e898c9b0ab1824863" => :yosemite
    sha256 "5b534dc90ef2b2374e0afd13ee160a912bb68b6cf5cbc046cebe13c5d636b677" => :mavericks
  end

  depends_on "readline"
  depends_on "go" => :build

  # List of Go dependencies and hashes.
  # Generated using: https://github.com/samertm/homebrew-go-resources
  %w[
    github.com/bobappleyard/readline 7e300e02d38ee8b418c0b4841877f1845d392328
    github.com/boltdb/bolt dfb21201d9270c1082d5fb0f07f500311ff72f18
    github.com/bradfitz/http2 aa7658c0e9902e929a9ed0996ef949e59fc0f3ab
    github.com/didip/tollbooth 9adc32f5171e833befc340a64b63602529fc0373
    github.com/eknkc/amber 91774f050c1453128146169b626489e60108ec03
    github.com/fatih/color 533cd7fd8a85905f67a1753afb4deddc85ea174f
    github.com/fsnotify/fsnotify 30411dbcefb7a1da7e84f75530ad3abe4011b4f8
    github.com/garyburd/redigo b8dc90050f24c1a73a52f107f3f575be67b21b7c
    github.com/getwe/figlet4go accc26b01fe9ddb12c1b2ce19c2212551d70af87
    github.com/go-sql-driver/mysql 3654d25ec346ee8ce71a68431025458d52a38ac0
    github.com/juju/ratelimit 77ed1c8a01217656d2080ad51981f6e99adaa177
    github.com/klauspost/compress 14eb9c4951195779ecfbec34431a976de7335b0a
    github.com/klauspost/cpuid 09cded8978dc9e80714c4d85b0322337b0a1e5e0
    github.com/klauspost/crc32 19b0b332c9e4516a6370a0456e6182c3b5036720
    github.com/klauspost/pgzip 95e8170c5d4da28db9c64dfc9ec3138ea4466fd4
    github.com/mamaar/risotto c3b4f4dbac6541f11ed5bc1b97d00ef06bbe34c0
    github.com/mattn/go-runewidth d6bea18f789704b5f83375793155289da36a3c7f
    github.com/mitchellh/go-homedir 981ab348d865cf048eb7d17e78ac7192632d8415
    github.com/mitchellh/mapstructure d2dd0262208475919e1a362f675cfc0e7c10e905
    github.com/natefinch/pie 13d3874dc4836d5db81d3a950aa5436b1eb23372
    github.com/nsf/termbox-go 8930de04764634cd4ac7b3bd33480681b194fe0c
    github.com/russross/blackfriday 1d6b8e9301e720b08a8938b8c25c018285885438
    github.com/shurcooL/sanitized_anchor_name 10ef21a441db47d8b13ebcc5fd2310f636973c77
    github.com/sirupsen/logrus f3cfb454f4c209e6668c95216c4744b8fddb2356
    github.com/tylerb/graceful cc92da329b6bafe9c05e73728fb377eea184e761
    github.com/xyproto/cookie b84c85ae2aa3e21b2c7fc8c37d5a3081c0c9c83b
    github.com/xyproto/jpath 19557bd0413e39439388198e12bf6be16583b785
    github.com/xyproto/mime 58d5c367ee5b5e10f4662848579b8ccd759b280e
    github.com/xyproto/permissionbolt 65ca75f842f2bdfd5f57c6e99fbd1b31bf5e5d21
    github.com/xyproto/permissions2 6a884b2c2914bfbc42c391ae5dd683a6331ef358
    github.com/xyproto/permissionsql d517b172d4846d40dce3870244009df6326c6bcb
    github.com/xyproto/pinterface 21f55042b599a5de383bcd9e9c839e920d33eeb6
    github.com/xyproto/pongo2 3789aabbe5087474a02f4879c0b0045fd5d90d96
    github.com/xyproto/recwatch eec3775073f11929973b0d06507a682f8061babb
    github.com/xyproto/simplebolt 349c7ad35b3b6e29a47f39ee122281911a067ff7
    github.com/xyproto/simplemaria 80759a73a6b576479bbf2baf955f7a46e04cb5b5
    github.com/xyproto/simpleredis de7b4cb9d1be983af7e9924394a27b67927e4918
    github.com/xyproto/term 9e12074e834ac795cf9e5d8ac4f3149babb59576
    github.com/xyproto/unzip 823950573952ff86553b26381fe7472549873cb4
    github.com/yosssi/gcss 39677598ea4f3ec1da5568173b4d43611f307edb
    github.com/yuin/gluamapper d836955830e75240d46ce9f0e6d148d94f2e1d3a
    github.com/yuin/gopher-lua 47f0f792b296190027f38d577f0860e2dad7a777
  ].each_slice(2) do |resurl, rev|
    go_resource resurl do
      url "https://#{resurl}.git", :revision => rev
    end
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "5bcd134fee4dd1475da17714aac19c0aa0142e2f"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "c4c3ea71919de159c9e246d7be66deb7f0a39a58"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
      :revision => "076b546753157f758b316e59bcb51e6807c04057"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "algernon"

    bin.install "desktop/mdview"
    bin.install "algernon"
  end

  test do
    begin
      tempdb = "/tmp/_brew_test.db"
      cport = ":45678"

      # Start the server in a fork
      algernon_pid = fork do
        exec "#{bin}/algernon", "--quiet", "--httponly", "--server", "--boltdb", tempdb, "--addr", cport
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      output = `curl -sIm3 -o- http://localhost#{cport}`
      assert_match /^Server: Algernon/, output
      assert_equal 0, $?.exitstatus

    ensure
      # Stop the server gracefully
      Process.kill("HUP", algernon_pid)

      # Remove temporary Bolt database
      rm_f tempdb
    end
  end
end
