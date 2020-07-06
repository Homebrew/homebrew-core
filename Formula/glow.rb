class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v0.2.0.tar.gz"
  sha256 "031a47a06767373ae7d0ad3b6dfd64075b93d66a8a980a7250358fc5f30d05f4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c21088d72f2e0e7f41b64c74b0b5c4b0494570ccde672998bf62f920dacdb7c" => :catalina
    sha256 "65d2045f3ecb6368b018706e65a32093651dcedf5aa6b0fab15bd60278452742" => :mojave
    sha256 "8cdd087d6817dde487cd09c3378048728cf492ab4e94188f76bf3bdbe4a1c168" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
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
