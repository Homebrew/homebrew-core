class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org/"
  url "https://github.com/magefile/mage.git",
      :tag => "v1.4.0",
      :revision => "49bafb86c808d73cabc5353d9ec040745dfab453"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/magefile/mage").install buildpath.children

    cd "src/github.com/magefile/mage" do
      # bootstraps itself without the need of another mage version installed
      system "go", "run", "bootstrap.go"
      prefix.install_metafiles
    end

    bin.install buildpath/"bin/mage"
  end

  test do
    assert_match /^Mage Build Tool v#{version}/, shell_output("#{bin}/mage --version 2>&1")

    (testpath/"magefile.go").write <<~EOS
      // +build mage

      package main
      import "fmt"
      func Build() {
        fmt.Println("hi build!")
      }
    EOS
    assert_match "hi build!", shell_output("#{bin}/mage build")
    assert_match "Targets:\n  build    \n", shell_output("#{bin}/mage -l")
  end
end
