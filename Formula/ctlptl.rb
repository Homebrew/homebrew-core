class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.8.tar.gz"
  sha256 "09191d6902115c2b4d463695224de87eb490e1865eb27583ec27e64d9a9ca12e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3baa95a78dbccb51f147359941e534feecf28c2c7df2f0c5bd52d3e88a9962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8aa64e0f9aef72af18247d8c154d21a6e59e8afbfc709ff777f94a30879fb34"
    sha256 cellar: :any_skip_relocation, monterey:       "17dceb2ad67241264914976d9ad48cb67b5c1da7aeee8310b242d577f3b387bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "141b74ba4cebd66e122fa8f5f6c5e3e4db5dbe971ad7c12dc741cabc7df0c08e"
    sha256 cellar: :any_skip_relocation, catalina:       "1630f34285047d6ddecc72ac2753b7fea0aec8d8ae7b41acabf469e522624e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1248bbc1fe748063a73411e7b8e4b8bbf06c2aa322059fe332f24e50450be5a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
