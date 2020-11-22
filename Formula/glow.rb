class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.2.0.tar.gz"
  sha256 "75d80dcd3258569e187d189f96f79de544332b72d635cc20b5111453d03c3a2d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ae142c6d10952894658f117a1649c43f1d7cacbfeca101d14457481d726eb63" => :big_sur
    sha256 "7ea44c9a9c87946f867665959348de2e319daf3c54d627bfdf0c153b4948c656" => :catalina
    sha256 "3c28670eecb15da000967c5045a448462df5571650adec20cfce9f475ad31a25" => :mojave
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
