class Copa < Formula
  desc "copa is a tool based on buildkit that can be used to directly patch container images given the vulnerability scanning results from popular tools like Trivy"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4261caa16e8ba25d5ead96a4fb3c033df4e4ec68305f5ce58714fe336e83f361"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(), "-o", bin/"copa", "main.go" 
  end

  test do
    assert_match "Project Copacetic: container patching tool", shell_output("#{bin}/copa help")
    
    EOS
    (testpath/"report.json").write <<~EOS
     {
      "SchemaVersion": 2,
      "ArtifactName": "nginx:1.21.6",
      "ArtifactType": "container_image"
     } 
    EOS
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6 --report=report.json")
    assert_match "Error: report.json is not a supported scan report format", output
  end
end
