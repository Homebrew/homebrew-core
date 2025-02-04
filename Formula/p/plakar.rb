class Plakar < Formula
  desc "Effortless Open-Source Backup"
  homepage "https://plakar.io/"
  license "ISC"
  url "https://github.com/PlakarKorp/plakar.git", branch: "main"
  version "main"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/PlakarLabs/plakar").install buildpath.children
    cd "src/github.com/PlakarLabs/plakar/cmd/plakar" do
      system "go", "build", "-o", bin/"plakar"
    end
  end

  test do
    system "#{bin}/plakar", "-help"
  end
end
