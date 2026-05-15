class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://github.com/checkmake/checkmake/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "450412ba6500ef7c4c8a0150a5e1a3d2e76591ce9f37609bcbd5508298ad9bef"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "830ad356f8143c6cf17c178be7e6b244982354975ffa8a4b2fa1b5150907b58d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4cc9b6deb720d7ef53cad7f243810dc3e1217307035256d7b56865eda287382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128dd99341f31a790f9ae61549bb735909989086659b192cecff3f0aeba556f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "62d2f5dcd3fd0fd6f1162bd67d58812aa5e59f78af2dc193c98c20b04eaa07fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac2838e91b6e12598749426385f3f02470cc749d78bb5783020a00fd65f82139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f82defd4eb6ae7267171725d0c0c672583ec1184463858b90d79b1dccf884c"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["BUILDER_NAME"] = "Homebrew"
    ENV["BUILDER_EMAIL"] = "homebrew@brew.sh"
    ENV["PREFIX"] = prefix
    system "make", "VERSION=#{version}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checkmake --version")

    sh = testpath/"Makefile"
    sh.write <<~EOS
      clean:
      \trm bar
      \trm foo

      foo: bar
      \ttouch foo

      bar:
      \ttouch bar

      all: foo

      test:
      \t@echo test

      .PHONY: clean test
    EOS
    assert_match "phonydeclared", shell_output("#{bin}/checkmake #{sh}", 1)
  end
end
