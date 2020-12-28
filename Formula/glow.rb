class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.3.0.tar.gz"
  sha256 "828d8453f026a24cd7a6dcf8d97213fe713cadcfab7ca969d5f4c8338d88bb86"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "875a1044ff25038e3e3f0cf74c849885b3f62fef942418402373511b533cdebc" => :big_sur
    sha256 "e2460a2d75a8689aa81040bacb8c2892b89a049cd92cdc44643e54b8bcc6c71c" => :arm64_big_sur
    sha256 "f0635d4d7cf60db408c0a6d9048551e7fdb8e0fd226046a9e67d80972b2e082e" => :catalina
    sha256 "86940c7791ad59c5977ae4ee150da983043df845a8b6f9c9d9c5e99c47f75651" => :mojave
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
