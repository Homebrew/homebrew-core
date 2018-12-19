class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.3.2-alpha.preview.tar.gz"
  sha256 "fe0a2766dbe9410e7b9873778c0fe7e693cb82e29db1ce246e9a7eeff2569ed7"

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
    system bin/"arduino-cli", "version"
  end
end
