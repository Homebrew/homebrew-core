class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v20.07.0/flank.jar"
  sha256 "d3a99fdaaa3000b4346201a7fed18afc2c8c5309c5ffa442a647a96a08cea21d"
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
    output = shell_output("#{bin}/flank android doctor")
    assert_match "version: v#{version}", output
    assert_match "Valid yml file", output
  end
end
