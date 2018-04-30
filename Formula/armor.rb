class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.8.tar.gz"
  sha256 "99e998388b4b4af00cfdea4ad870c606338e56f45ca279b09361f01fe1fa0012"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ad1d41229e8c686cc2b0cf29251f118b93399b0eff8d0ddfdd31b65586370d" => :high_sierra
    sha256 "7b6c58487669e0263adee056d3e8047d6dfaab2296c30ccdef4fff7a526b8726" => :sierra
    sha256 "b706cabf7251aecc22d219a4c4aa9cb30d1a58e578b6b7015934a5ec2f40e608" => :el_capitan
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
