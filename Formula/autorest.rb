class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://github.com/Azure/autorest/releases/download/AutoRest-0.16.0/autorest.0.16.0.zip"
  sha256 "bc909aaf3db2105a5d709c940c4d120c5b71047539c2068d484ced1be47650c3"

  depends_on "mono"

  def install
    libexec.install Dir["*"]
    (bin/"autorest").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/autorest.exe "$@"
    EOS
  end

  test do
    system "curl", "-#SLO", "https://raw.githubusercontent.com/Azure/autorest/master/Samples/petstore/petstore.json"
    assert_match "Finished generating CSharp code for petstore.json.", shell_output("#{bin}/autorest -n test -i petstore.json | tail -1")
  end
end
