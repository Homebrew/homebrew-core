class Punto < Formula
  desc "Composable Dotfile Manager"
  homepage "https://rahulsom.github.io/punto/"
  url "https://bintray.com/api/ui/download/rahulsom/punto/punto/0.1.0/punto-0.1.0.zip"
  sha256 "9599a98dcbfe06e556c113c3d19f21698345263a2a7cd7725064cb23d3dbef76"

  def install
    bin.install "macos/punto"
  end

  test do
    system "#{bin}/punto", "--version"
    system "curl", "-s", "https://raw.githubusercontent.com/rahulsom/punto/master/src/test/resources/sample.punto.yaml", "-o", "/tmp/punto.yml"
    system "#{bin}/punto", "config", "-c", "/tmp/punto.yml"
    system "rm", "/tmp/punto.yml"
  end
end
