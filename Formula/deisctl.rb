class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "https://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.4.tar.gz"
  sha256 "7f1b378d884d5b42d0b03df7c79aa31cc6081bcc4c23d880101e98fdfe7cb89a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "16becd65687b6d388850461b7fa9d949cdbc6b6f30d5977f44be28f174c49dc4" => :mojave
    sha256 "8a73a808a0b8f9d995cb4dd0e41c48b13749527c50055a187ed18244db851884" => :high_sierra
    sha256 "8661535566fe1d2484f5a0a2a4e6450ee026fe5c56490b335db9a5b34beb6984" => :sierra
    sha256 "2294410457372fb3f076532923179782e94bcf675e8b0ccf9c65d4a691c1d382" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deisctl", "deisctl/deisctl.go"
  end

  test do
    system bin/"deisctl", "help"
  end
end
