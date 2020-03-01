class Cacli < Formula
  desc "Train machine learning models from Cloud Annotations"
  homepage "https://cloud.annotations.ai"
  url "https://github.com/cloud-annotations/training/archive/v1.2.30.tar.gz"
  sha256 "f10758c46deefc90d08967f6e0f7d232947d5c795b9c533a2ffa898363391e81"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7e1fe0b308c64d84c9b72f2a3d2b18e4b174a21654543658c1a709e34eab5cc" => :catalina
    sha256 "2579efd4d60bff9f8c5ec22ce1e80b491f61a7c22d6619ff9c7cc8462bc45d8e" => :mojave
    sha256 "fe87f0eafc1c581f15b8eb0c6615efeeddeed1c7032dc3d5a108431ed6578282" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cacli" do
      project = "github.com/cloud-annotations/training/cacli"
      system "go", "build",
             "-ldflags", "-s -w -X #{project}/version.Version=#{version}",
             "-o", bin/"cacli"
    end
  end

  test do
    # Attempt to list training runs without credentials and confirm that it
    # fails as expected.
    output = shell_output("#{bin}/cacli list 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output.
    assert_match "FAILED\nNot logged in. Use 'cacli login' to log in.", cleaned
  end
end
