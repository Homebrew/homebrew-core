class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v20.08.0/flank.jar"
  sha256 "9ddeea5406e51daaec6e3903e20f0ddd4f518c0e26c1853ddfc6f880fc0cf693"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    (bin/"flank").write <<~EOS
      #!/usr/bin/env sh
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/flank.jar" "$@"
    EOS
  end

  test do
    (testpath/"flank.yml").write <<~EOS
      gcloud:
        device:
        - model: Pixel2
          version: 29
          locale: en
          orientation: portrait
    EOS

    expected = <<~EOS
      version: local_snapshot
      revision: e1637b70b2962c6ab34e7656a8def6c0067e7936

      Valid yml file
    EOS

    output = shell_output("#{bin}/flank android doctor")
    assert_equal expected, output
  end
end
