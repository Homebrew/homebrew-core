class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.8.tar.gz"
  sha256 "1f4881a801fbfab5c15fe3dbb143e9134bcbf2b71682f7eb67774a07d0780e4b"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f95ea0775ee19406dbea2fb9e503e124946cee21d338ad60534afd34ccd193f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f95ea0775ee19406dbea2fb9e503e124946cee21d338ad60534afd34ccd193f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f95ea0775ee19406dbea2fb9e503e124946cee21d338ad60534afd34ccd193f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3ebd3633506770e67e617c77d63c9c13443f8dea3ccb7b575a9b7d395968a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a7511feb78ca10888a5aca4d9df5ad420a3d06a89c229e255ee14e721063754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499b17e9acfdf80a57d602f3a8849d035335304384a1478d8b11a4848fe3c50f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
