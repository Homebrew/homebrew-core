class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://github.com/checkmake/checkmake/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "450412ba6500ef7c4c8a0150a5e1a3d2e76591ce9f37609bcbd5508298ad9bef"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "039e9eca37bf85e2f4b86bf6297b7e28821087cc0c18730ad4638ff66402705b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e44429a9d3605e6d61d1fc886e01e6f25b2eeeb70350b6e3340214d858f6c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64d7b1cdeb8abbb4d9dbe1d56490b391b9233c9f3fb12f3e3ff07523d7c29186"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6dcdc8193870c49f52b7c684ae251ccfbed991a3d0d4830b582c5e563a720007"
    sha256 cellar: :any,                 x86_64_linux:      "cc596704a788d87ef48ac1e1303ba308c6949707644b5bd7c1f1e4e4b122a173"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["BUILDER_NAME"] = "Homebrew"
    ENV["BUILDER_EMAIL"] = "homebrew@brew.sh"
    ENV["PREFIX"] = prefix
    # The default target runs an unpinned `golangci-lint@latest`, whose new checks fail on the test files
    system "make", "install", "VERSION=#{version}"
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
