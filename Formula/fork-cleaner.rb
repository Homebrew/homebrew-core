class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.5.1.tar.gz"
  sha256 "b3a52059683b3151717a51d2496327e4b2d16a8462e8762a7135d54fa2dd2a10"

  bottle do
    cellar :any_skip_relocation
    sha256 "15fbcd401a094d4043125534ed65d288d83689f9388836a21f78178a6b56337e" => :catalina
    sha256 "2121f81a8ba2a346bd3c996ecdbcca57dea8508306ed662a1572b198f419f860" => :mojave
    sha256 "057111aea39d7d2a1335dab715121e31e98971a611627f94dbb6c52ddea8bf34" => :high_sierra
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
