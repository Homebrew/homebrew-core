class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.5.tar.gz"
  sha256 "0283492ab8bc92305418e90a5704fda89c6f83fc75a8ce30659d35ac55696d2a"
  head "https://github.com/labstack/armor.git"

  bottle do
    sha256 "795298b5bffd9cca67c89ff7fa1bd565c399142c4a97d07c72fdeaa103064049" => :sierra
    sha256 "66d6439165afcccc2991aa216e2f50b0651eab278b910661ee7655f10642abcf" => :el_capitan
    sha256 "dd88699be4c89ef5520903547ccc0e09f0b178444000e5696032b4e50f6738e7" => :yosemite
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
