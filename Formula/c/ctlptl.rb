class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.40.tar.gz"
  sha256 "150c80e1855530871bd815cae466d559bddebae88e74e80f64a743bf10236d4d"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08791701e964b9592a0e70ebe6f66a60c4ef45f60da25a34487ebed9aa2ea6d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930e48d7e62fb86dc4a3d833dc7bc709cd52ebf3ecccb29c29fcc85cbf76db73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849305be4d6845d03a45a4095182744cf52a23674ab47f975a7b77fe5e2d79e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7659d74ff23c82f25783815074811622c79b35749537f0843daf1c41556d8123"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b1ace1ff8e2ffbe788d0f33f7969d2d2272b4217b38bd5137c685c74dd01ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0282da94f64161002eab49d6d3846d600849b36e63c36db96b4bfb4b740e0c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300432a6c6c1ef111b46a4fed7af24162e918da54cdd676f7687a5390fa78b02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
