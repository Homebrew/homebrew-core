class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.6.1/bundletool-all-1.6.1.jar"
  sha256 "17bc86d13c2db5a280aa0a718f09f09434a3c5b50d3d7c3c5ae9f77afcd1d1d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36434f9a6470a18448da68d2a2c6767b00730ff8afb50149caa2a96f724bb1b7"
  end

  depends_on "openjdk"

  resource "bundle" do
    url "https://gist.githubusercontent.com/raw/ca85ede7ac072a44f48c658be55ff0d3/sample.aab"
    sha256 "aac71ad62e1f20dd19b80eba5da5cb5e589df40922f288fb6a4b37a62eba27ef"
  end

  def install
    libexec.install "bundletool-all-#{version}.jar" => "bundletool-all.jar"
    (bin/"bundletool").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/bundletool-all.jar" "$@"
    EOS
  end

  test do
    resource("bundle").stage do
      expected = <<~EOS
        App Bundle information
        ------------
        Feature modules:
        	Feature module: base
        		File: dex/classes.dex
      EOS

      assert_equal expected, shell_output("#{bin}/bundletool validate --bundle sample.aab")
    end
  end
end
