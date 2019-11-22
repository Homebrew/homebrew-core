class CfTool < Formula
  desc "Command-line tool for Codeforces contests"
  homepage "https://github.com/xalanq/cf-tool"
  url "https://github.com/xalanq/cf-tool/archive/v0.8.2.tar.gz"
  sha256 "04eeb0ebfd2f15f81940012def95ec964498f7053029aa8b192d99c5a88bb98b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c28ad65369bed1bc74105242097fca990c3b4ca875cca731eed928f547df1b4" => :catalina
    sha256 "ea7a5befc573b9c55cb4ce6f5f65b33141737c767548ad98fc50689b8a8c7747" => :mojave
    sha256 "9e0ab03bf2a895310eea7a6bc73221ffeb490416be1fb3bf9a77eda439e17159" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xalanq/cf-tool").install buildpath.children
    cd "src/github.com/xalanq/cf-tool" do
      system "go", "build", "-o", "cf", "-trimpath", "-ldflags", "-s -w", "cf.go"
      bin.install "cf"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/cf", "list", "1256"
  end
end
