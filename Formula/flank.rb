class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v20.06.2/flank.jar"
  sha256 "2aa7e5e5fc83396fa95a2f41341a39d07ee289289e67bdfea874fd5e521777b9"

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
