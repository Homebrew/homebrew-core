class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.7/gbox-v0.1.7.tar.gz"
  sha256 "4fe828140713d863a9995ce0e93f11d20f5b9e46ea1270065842d8bd6363e7d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16a2fa965094faf47e170670b9bb1577647fb9b0520413307993fda79a44b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a00e6482f8b8c7691c0c5ef20682502a4e91788af15ba04de77bf7f2bc059cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfcb5fe5e9774c200f69182fbb84e46e4e31dced61833248613f1f22d2c8a657"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ebbc1bc091eb5b1469255850030002f0c2532e2578d39b5dbd3db4f3e9d268"
    sha256 cellar: :any_skip_relocation, ventura:       "19d322d8225961ab43dcf76aa48269daf6f3a5de4fb11c517a5982274d3eb528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb7a657f247ffab923a084c9fa90ebdb44b384ee80cc8c7bbd52e0c77469c8e"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "yq"
  depends_on "carvel-dev/carvel/ytt"
  depends_on "carvel-dev/carvel/kapp"
  depends_on "kind"
  depends_on "jq"
  depends_on "node"
  depends_on "frpc"

  uses_from_macos "jq"

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  def caveats
    <<~EOS
      This formula requires android-platform-tools cask to be installed.
      If you haven't installed it yet, run:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # Test gbox profile management
    add_output = shell_output("#{bin}/gbox profile add -k xxx -n gbox-user -o local")
    assert_match "Profile added successfully", add_output

    current_output = shell_output("#{bin}/gbox profile current")
    assert_match "Profile Name: gbox-user", current_output
    assert_match "Organization Name: local", current_output
    assert_match "API Key: xxx", current_output
  end
end
