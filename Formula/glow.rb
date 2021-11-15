class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.4.1.tar.gz"
  sha256 "ff6dfd7568f0bac5144ffa3a429ed956dcbdb531487ef6e38ac61365322c9601"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b0a9d0e4c3cebc6a40e0209777c2bd98dc819ddca404602949cd835f8d82274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7e15ba449c8f2720d93f8bde3f80fa3e27c82cf5bacc2944114ec4650a25d45"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1113f3305dc5643cf3e2ac2adca6b2be48e5e1f723721ebef023afb5425c6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c76069ff642658ed8b51fd903b1a5a5892247de72f7f62f29e10d46cae3e6caf"
    sha256 cellar: :any_skip_relocation, catalina:       "4e713fa69e7d61139e8e7f904c675d2bfbabba9977316c22b4868f3bf5e0c77e"
    sha256 cellar: :any_skip_relocation, mojave:         "22926fb845a37fd3dd9bee91e5af5575204480c5dfa2a6826cdb70fed07a80d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57317e524f7ca1af42f21c91b1e387faa9a0c7e33efae5193443be86dd38a83"
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
