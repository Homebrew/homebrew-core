class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  # git checkout needed for buildInfo support
  url "https://github.com/golang/vuln.git",
      tag:      "v1.7.0",
      revision: "617f44b718537dccdea1915395650e0529e3b72e"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21dddabe5c6625c4625a5cd00f048df0d846f8e5dfb93861f0d2d60ae9bf0245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21dddabe5c6625c4625a5cd00f048df0d846f8e5dfb93861f0d2d60ae9bf0245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21dddabe5c6625c4625a5cd00f048df0d846f8e5dfb93861f0d2d60ae9bf0245"
    sha256 cellar: :any_skip_relocation, sonoma:        "28076311022c662df27fa88f6331099738b8a22e9fe6d4cd8b4714ab6f5bd6e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6008e722463665fded7470b08f91d29f3a9453e06d08e4f420e65dd0c3208ff"
    sha256 cellar: :any,                 x86_64_linux:  "ee2fcfd70cdb46c0feddfb0b8d15bdc77ec5e36116ec6c50ef1b07e90c0aa21d"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
  end

  test do
    assert_match "Scanner: govulncheck@v#{version}", shell_output("#{bin}/govulncheck --version")
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~GO
        package main

        func main() {}
      GO

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
