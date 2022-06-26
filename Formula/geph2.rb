class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.5.tar.gz"
  sha256 "4afca74d97c890061d34c8885258d6f4a48c63e69c7e8b56719fdae68c4f306b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18b805c6d02c073780a49837ec72db79fd6fd310df826197036d684c727df1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b6f54e3938d4362d85d4dda831ffce4ada5635433d490e1fb762fae70fce42"
    sha256 cellar: :any_skip_relocation, monterey:       "5576fc9fa6870e5b33cdf3dd448b067533d6806993a597e2f65c2c9a4d70feea"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d6622ad8567fda7a73bd85ae3ca5229bd83c6289d3e56aa2b7c6aa67eb0c621"
    sha256 cellar: :any_skip_relocation, catalina:       "c289cb8558247b38814c51298da6ba86ed16ab0f9ee49eeb097464aee5702189"
    sha256 cellar: :any_skip_relocation, mojave:         "8133f7174bdd1218ad3799543b85d2e932ffab60b89181ce209b314c57847c9d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "392a4199771a8ff4c5aa1c45bd3225640d9949aa1e2a9af915e488093fe84ff9"
  end

  # Geph has been rewritten in Rust: https://github.com/geph-official/geph4
  deprecate! date: "2020-04-24", because: :repo_archived

  depends_on "go" => :build

  def install
    bin_path = buildpath/"src/github.com/geph-official/geph2"
    bin_path.install Dir["*"]
    cd bin_path/"cmd/geph-client" do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-o",
       bin/"geph-client", "-v", "-trimpath"
    end
  end

  test do
    assert_match "username = homebrew", shell_output("#{bin}/geph-client -username homebrew -dumpflags")
  end
end
