class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  version "2.2.0"
  bottle :unneeded
  url "https://get.pulumi.com/releases/sdk/pulumi-v#{version}-darwin-x64.tar.gz"
  sha256 "8cab8e2ffe9b98f652cd4543d8af4a1fe9062d728912a4376e310acf48c1de8d"

  def install
    bin.install Dir["*"]
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end

