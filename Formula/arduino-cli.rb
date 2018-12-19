class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.3.3-alpha.preview.tar.gz"
  version "0.3.3-alpha"
  sha256 "bd47c46efa9e3c72e1fa915f96e3aa9742fbf220e75ef254b44b3e6be8332d0e"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/arduino/arduino-cli").install buildpath.children

    cd "src/github.com/arduino/arduino-cli" do
      system "go", "build", "-o", bin/"arduino-cli"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "arduino-cli version #{version}.preview", shell_output("#{bin}/arduino-cli version").strip
    system "#{bin}/arduino-cli", "core", "search", "arduino"
  end
end
