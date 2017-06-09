class Hyper < Formula
  desc "Client for HyperHQ's cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
      :tag => "v1.10.12",
      :revision => "5473ab18b84afad71f49d9aed4dafa857e331b4a"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ae87901488d4863857ea90f23548f8740b5d17f0473446e34379ae2c80ea312" => :sierra
    sha256 "55ed18d787fd0971c037454fa1529e72b666fac9fb570a8d290448e462008778" => :el_capitan
    sha256 "a0c8b853e922595c738cfa0c341f4f6decd9784f4b526769a5dddbf22cefaefd" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hyperhq"
    ln_s buildpath, "src/github.com/hyperhq/hypercli"
    system "./build.sh"
    bin.install "hyper/hyper"
  end

  test do
    system "#{bin}/hyper", "--help"
  end
end
