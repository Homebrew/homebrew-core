class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.3.tar.gz"
  sha256 "4374d8318646bd73159d694ea13df8c1e17e8f5d4b484ff93da6701223d3dc15"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17bd34063f7c7ef08e23f31bfcf55380c903bdfc3b22e3a434b70b31198fbb6c" => :high_sierra
    sha256 "10609d150d4fbdadee6f72abcd301ef597aa27b029e088c8ac940ff8ffccdf09" => :sierra
    sha256 "083da88ebedde78780934098477e04a43fc563351f6c958392dc35dc8552f8be" => :el_capitan
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
