class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "57bc2cd8b357aa3b3d8138c357ec34dd98b881fc01f8b067465757cd45ffdf0e"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67b66eed4b457c19ea605fbc859fdad849c70860834ae4b78002dc058b086818"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b66eed4b457c19ea605fbc859fdad849c70860834ae4b78002dc058b086818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b66eed4b457c19ea605fbc859fdad849c70860834ae4b78002dc058b086818"
    sha256 cellar: :any_skip_relocation, sonoma:         "50099a8417fbc33f380b1db744e3dfe0ef9f04e0587fe061b5c93be7c98a9fea"
    sha256 cellar: :any_skip_relocation, ventura:        "50099a8417fbc33f380b1db744e3dfe0ef9f04e0587fe061b5c93be7c98a9fea"
    sha256 cellar: :any_skip_relocation, monterey:       "50099a8417fbc33f380b1db744e3dfe0ef9f04e0587fe061b5c93be7c98a9fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087bb2f680445de07dc95b46675f0204b753f478efd4e0aaec6105e8858d81bd"
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
