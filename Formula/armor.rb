class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.3.5.tar.gz"
  sha256 "00c7a27f8f59d9831f1c7234e05ee360280c845ed2e48ab2ae1c05db5cbcfc60"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d54101426b9e42efa1fec24f18613cdf3b2ee43184d0e9740c43bbd7bff15563" => :high_sierra
    sha256 "31c834797830ae814a7068087344e8e570ffb430f3d9a439fcd29c149d268113" => :sierra
    sha256 "6823f1631dfad06e62ea09df71332b4cc0220236943a887b24139e3ed67548a7" => :el_capitan
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
