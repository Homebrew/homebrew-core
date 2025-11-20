class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "dd19acaac32fa525f3b5bc3403dced0f79d9970dcebedd5fefbd1807add978e7"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99593624a26a691635d9cf5240fab7e974d551f962c2ce6cccc66bc53f69ac1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99593624a26a691635d9cf5240fab7e974d551f962c2ce6cccc66bc53f69ac1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99593624a26a691635d9cf5240fab7e974d551f962c2ce6cccc66bc53f69ac1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae526484a05a7c1e500cac44ac31fe31e192dd51ba62c245237506449066734a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8732cac6173a8d023e6e3f7e5b5c8889521eed087766652385bb4fc7630d453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b600cf6f456086f638d405dc78ec29af8157ddca281609d560b795f5b5d7ab88"
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
