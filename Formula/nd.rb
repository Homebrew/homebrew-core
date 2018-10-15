class Nd < Formula
  desc "Node.js version manager"
  homepage "https://github.com/1000ch/nd"
  url "https://github.com/1000ch/nd/archive/v0.2.0.tar.gz"
  sha256 "34d9dc3731274755347e16660ec0c685c69fde39a8861b3bdd98d2d1d31aad70"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/1000ch/nd").install buildpath.children
    cd "src/github.com/1000ch/nd" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"nd"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/nd", "version"
  end
end
