class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.8.tar.gz"
  sha256 "99e998388b4b4af00cfdea4ad870c606338e56f45ca279b09361f01fe1fa0012"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31ca2682861bf082be5f7017c9748b9c9a17d33bcecb2ca313774b5e229fe84e" => :high_sierra
    sha256 "71cd49a430ccf9146cf753a2d036e044aac76ab8fdcafb989080a39abe723ac1" => :sierra
    sha256 "315a23504e4f8230065c3bfb36182270f97933c656a72b1999c248ba6f969087" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
