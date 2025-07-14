class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "d35214fa6d799190945d2e0bf313dc31b52938d94ec04f40bb45015a9f409f16"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "981490c9fdfdc4d52da78ba943d4f44cae48e01e11d6751acbf5f5595de1d961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981490c9fdfdc4d52da78ba943d4f44cae48e01e11d6751acbf5f5595de1d961"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "981490c9fdfdc4d52da78ba943d4f44cae48e01e11d6751acbf5f5595de1d961"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9c5c8cd52f2c3c2b35f4e7ee6057126f7f9fbeace983b3fd3171971916f997f"
    sha256 cellar: :any_skip_relocation, ventura:       "b9c5c8cd52f2c3c2b35f4e7ee6057126f7f9fbeace983b3fd3171971916f997f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32aadeab3a73d9b9258ab15dbfb977838d8dafb52285dbad8d18d053ffc38a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f67b8176b82a6dd35eb7895fd542fd705e9fe7ce4ba947603ae2ee59fa38d1"
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
