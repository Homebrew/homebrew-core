class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "70f82d70f3a6757babbeb4e6834536e572d1c822180619ac74b649e3e4f247fb"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ce3ef2c7ee9471bf980f13386092cb8654dc18a92ef496a4b09f56f276f152f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ce3ef2c7ee9471bf980f13386092cb8654dc18a92ef496a4b09f56f276f152f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ce3ef2c7ee9471bf980f13386092cb8654dc18a92ef496a4b09f56f276f152f"
    sha256 cellar: :any_skip_relocation, sonoma:        "74716a77803293ddb2ed331dbf010e38882a575d3b2871c34e81081907498389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8183b30f602d11264f94398633401078cf97a8c85b5db197667b2d54d823282"
    sha256 cellar: :any,                 x86_64_linux:  "7cd2a3110967c2c555d05862b2e878b6bb16f729baa1a4651b55929a3be57972"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
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
