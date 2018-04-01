class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.2.tar.gz"
  sha256 "bdc8be0856cf3305bb53413b6f79411156a58ec2c87c00cb17aac5c64840f5dd"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46960e226c5d13682238366721a43116ffe665bac163f643f0d53ecfb8ff7253" => :high_sierra
    sha256 "0f2b791f5f4a889fcee60fc5cf566afdb24628f6e0db397bc82901e10db6f1e0" => :sierra
    sha256 "d46f0b4aa448e08680b6875b2505143e1f892f3725dc49cc3f8cd411a6048581" => :el_capitan
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
