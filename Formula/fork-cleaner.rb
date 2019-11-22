class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.6.0.tar.gz"
  sha256 "14f34c9fbdfb868e7c33664e6a3997a53f9b4e3b1516a71cff8d27423f66ab6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca8629c6ca7800ee9798d4acd14769bc86a7dd6d410b5699458adca6b4f69114" => :catalina
    sha256 "c61fdbd8b7b70450c79f01408332fcce4ffa68aad3aec467d663b1aaa76b3960" => :mojave
    sha256 "5101681b2fbcd850eaab43fa2c55dc5d0e6df26565a185a9e30a3bba39cdcc03" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children

    cd dir do
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
