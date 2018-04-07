class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.5.tar.gz"
  sha256 "e2e7b51aeb752117f5979d9048ce63ff8ef5f776ef62bedb6afc99f90621e80e"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21be77ff38c6386a6482f04c09c879c0591c5ed4e12716be3c4b852a0cce4511" => :high_sierra
    sha256 "fdbbba518490121c6e2976bc33e92d830a415c4145804f61fdedb2c9f0baaf8f" => :sierra
    sha256 "a262d7c51ab1557ed06fc880980e1e90bc2278a21ad4cda927e2ba09b34cac45" => :el_capitan
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
