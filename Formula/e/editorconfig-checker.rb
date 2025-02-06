class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "caa296ed32e34edd579ca239cdbbfd74d5e00f8736c56a1fca7d0350fe18492d"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4af3b8717a3b2077ecf64e7165e0665bc403afa8ec62c0a5710bf33a45aa148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4af3b8717a3b2077ecf64e7165e0665bc403afa8ec62c0a5710bf33a45aa148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4af3b8717a3b2077ecf64e7165e0665bc403afa8ec62c0a5710bf33a45aa148"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab433bbead68e79dbbe8f3d339f5519bc94ec5670054ac515c96215e03551eb"
    sha256 cellar: :any_skip_relocation, ventura:       "8ab433bbead68e79dbbe8f3d339f5519bc94ec5670054ac515c96215e03551eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0062e974be954072f792cfe9bedb17f0c6124ef2aab67211c7a765ae43438b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
