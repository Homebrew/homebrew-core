class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.7.tar.gz"
  sha256 "1e04be1274b875a90f3ca1b5685f0e2c2df79ae3b798a1c56395d0b5b5b686b3"
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa20b282e2ae3d81dc7241a35a4f4cb2f94ec6252426adbe817b31d4738a1d75" => :catalina
    sha256 "21cd4660fbaf3cf7ed98429dfb90d14ca88f11a7f728b46cde79019dbbb02540" => :mojave
    sha256 "7496c47f6ea70bd68e074f1ffbfac585b45faba59d94b706dd2ea57e2388508f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":45678"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:45678")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
