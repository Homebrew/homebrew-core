class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "7b2b38e2e2d8dbb506333fb42331afb00331b72b55e9cdeda4d0cccdc3d1f894"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c75363ddac63304760789e897faf0cd5bfbaa13262ffe956cf53e2bfd48ddaef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75363ddac63304760789e897faf0cd5bfbaa13262ffe956cf53e2bfd48ddaef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75363ddac63304760789e897faf0cd5bfbaa13262ffe956cf53e2bfd48ddaef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f113ef16b0289abf10193b8a704899d2b3510135f5fa10feadcdebb843f719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "635c0e95df033ac77661c42a343b510ee1821f08e28a9cff75658420f703dd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8333744ce6dc5a77ccaf976107230d6def5e7b4672c92ab9858fa7a3d23eb1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
