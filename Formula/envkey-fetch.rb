class EnvkeyFetch < Formula
  desc "Give it an ENVKEY, get back decrypted config as json"
  homepage "https://www.envkey.com"
  url "https://github.com/envkey/envkey-fetch/archive/v1.2.8.tar.gz"
  sha256 "4d1f55ba8d1c024ddc49752979439d035beb890ddd1fe8b40805aa048c5a5bee"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"src"
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "envkey-fetch", "main.go"

    bin.install "envkey-fetch"
  end

  test do
    shell_output "#{bin}/envkey-fetch"
    shell_output "#{bin}/envkey-fetch 000", 1
  end
end
