class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.5.tar.gz"
  sha256 "e2e7b51aeb752117f5979d9048ce63ff8ef5f776ef62bedb6afc99f90621e80e"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "203fb983d4af0d66a97cfcde656d9ef7fe9e23be9a685a05955c09567a4181ac" => :high_sierra
    sha256 "afcb9883f3a7184104d511fdfde2f64523a02dae28578593914884c1177fce28" => :sierra
    sha256 "01a5cc5f60765147c7425bebfa18b976422479fa8b4d457d410b6258cdd5dd1e" => :el_capitan
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
