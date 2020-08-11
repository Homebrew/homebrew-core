class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v20.08.1/flank.jar"
  sha256 "eb7ab6119a4cd653bf4b8b763269bf42df0c02bbf925a94411b957b76efd4d94"
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
