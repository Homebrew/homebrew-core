class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  version "2.1.1"
  bottle :unneeded
  url "https://get.pulumi.com/releases/sdk/pulumi-v#{version}-darwin-x64.tar.gz"
  sha256 "3efe812e88e0edc55107efad8ef0f65ca35b2bdcc669fa656cde68cbcbe11808"


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

