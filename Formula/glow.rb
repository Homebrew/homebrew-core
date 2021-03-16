class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.4.0.tar.gz"
  sha256 "97d373e002332e54e2fb808ea38f098ca49e2b88038c115bd6d33d0b3b921495"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1eae4d2edadf09016118ba6ef4220acade395c455ad997857eab3dc0803ff82d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c379ca5e4ac4a0e5e4fce06b5615e11a349d891cad0c6b1d7c3084fca4da2082"
    sha256 cellar: :any_skip_relocation, catalina:      "bd1c7fe06a82180bc34e136ca27ae1681555d5fb7b0bc9f4e374bfe6fd0ff0c9"
    sha256 cellar: :any_skip_relocation, mojave:        "4c3069a7e719ab28a236df5fedc2a7f57a9e6429d9c6c1d606f3a827e44e0a7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/name
  end

  test do
    (testpath/"test.md").write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS
    assert_match "# header", shell_output("#{bin}/glow test.md")
  end
end
