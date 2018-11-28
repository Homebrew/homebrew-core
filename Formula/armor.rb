class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.13.tar.gz"
  sha256 "1e80b70c2fa245800594f3ef7b6bb14d2af4fda2a8622d3c8a0a28f9ef6c4629"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06688ea6376d5442935ae75c719f63e1f6302384b1197d790cf01feb35dfc645" => :mojave
    sha256 "4aa066a1dc4f908c31168cb9a3ace4372d41b00f6b7f653fb957625f4e2c4145" => :high_sierra
    sha256 "aeb2fda18ebb214da91feefd22f4476197ae81abbf6a766bd2c53ab8706d9d47" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
