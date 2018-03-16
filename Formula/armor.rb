class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.1.tar.gz"
  sha256 "b36b3ee4b4e0960d17f4c2c03efe2f5002734dbfb415eec15bd499a01473dae1"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "132b19ef4edf3d42d34adc15b18809975bdb1a863ae592ea2ccca1e97b7a384a" => :high_sierra
    sha256 "79df01cadca68fd4b53b979523ac3d997e7eb5e5c03d29f5eabc03ad2c2ed07a" => :sierra
    sha256 "b1e8726ceec7f8b21c53b4469f003d4f752004b4830d4f9a5a89e87d9951972f" => :el_capitan
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
