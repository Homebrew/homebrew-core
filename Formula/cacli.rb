class Cacli < Formula
  desc "Train machine learning models from Cloud Annotations"
  homepage "https://cloud.annotations.ai"
  url "https://github.com/cloud-annotations/training/archive/v1.2.30.tar.gz"
  sha256 "f10758c46deefc90d08967f6e0f7d232947d5c795b9c533a2ffa898363391e81"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b2d628a0cc4ba4e426cbd5afea64c3ec1af0877aeee605e3536ec57817e7924" => :catalina
    sha256 "ff5f177e8708eeb3567feedf4ff48e5c233b1cc9283153dc6437e6f651da502b" => :mojave
    sha256 "90127c81c2ae488e493ae7aae91d2a783e790fdb4809d9c620a093289f425cb0" => :high_sierra
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
