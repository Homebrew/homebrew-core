class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman/archive/v1.6.2.tar.gz"
  sha256 "587ae86423df96fd5f5409f1af1a1ab763274d780c0b3f8651202caf840050dc"
  head "https://github.com/Praqma/helmsman.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/Praqma/helmsman"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install "helmsman"
      puts "Happy Helming!"
    end

    prefix.install_metafiles path
  end

  test do
    assert_match "kubectl", shell_output("#{bin}/helmsman -verbose 2>&1")
    assert_match "Helm:", shell_output("#{bin}/helmsman -verbose 2>&1")
  end
end
