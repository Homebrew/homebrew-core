class Cloudcrypt < Formula
  desc "Universal cryptographic tool with AWS KMS, GCP KMS and Azure Key Vault support"
  homepage "https://github.com/VirtusLab/crypt"
  url "https://github.com/VirtusLab/crypt/archive/v0.0.5.tar.gz"
  sha256 "8427002019acb8b04a8481fb6a02b7259ad18319cf1e4d3b33a2b457245a6b63"

  depends_on "go" => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["BUILDING_FROM_TGZ"] = "yes"

    bin_path = buildpath/"src/github.com/VirtusLab/crypt"

    bin_path.install Dir["*"]
    cd bin_path do

      system "make", "dep"
      system "make", "status"
      system "make", "static", "NAME=cloudcrypt"
      bin.install "cloudcrypt"
    end
  end

  test do
    system "env"
    system "pwd"
    system bin/"cloudcrypt", "-v"
  end
end
