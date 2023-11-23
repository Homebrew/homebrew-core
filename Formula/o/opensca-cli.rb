class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.io"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli.git", tag: "v3.0.0"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build",
    *std_go_args(ldflags: "-s -w -X 'main.version=#{version}'"),
    "-o", "#{bin}/opensca-cli", "main.go"
  end

  test do
    system "#{bin}/opensca-cli", "-version"
  end
end
