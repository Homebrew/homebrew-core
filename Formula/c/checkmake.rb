class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://github.com/checkmake/checkmake/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "450412ba6500ef7c4c8a0150a5e1a3d2e76591ce9f37609bcbd5508298ad9bef"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03b0296c51a1a1591cfb4ba020fb11433650c830e1740bb5dbf9c93dd5bdfd36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5495d72ffcfc0321d0246cb8c413d9fb06d441342d4687b4d6439119acde275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b73e17530d40a205b4bcdba99d62074de8a667d84c2028fa54f2bec275f9604"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0d3fd2a9648ec4ca6786626bb78b19e332aa7690ea423d402c7b0675fbd3990"
    sha256 cellar: :any,                 x86_64_linux:      "3df3736989476f56406c25e1537d61c442795abac9804c3106d2fb293818efea"
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
    generate_completions_from_executable(bin/"checkmake", shell_parameter_format: :cobra)
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
