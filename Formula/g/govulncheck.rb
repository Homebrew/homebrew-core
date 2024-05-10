class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "67a439d8142f9e214581bb0601a46efe59d8c13ffb5bc3334efac7c84167cb40"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b70985a8013c54bf662af5aa8243a30c9476cb05fee29d4fbab8fa800fcdf02d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a46c897fb03295392f29df2518a6b15bb371b21c2918657e9c5e004dfd8c6f9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c45bc569d09faaaf32f498b54017f4a65871065570100ba5c45f8f66d7a2a9a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b530027656d8b773f8e5806971e19b9dda33d07b7e4133972c257659c5d3f453"
    sha256 cellar: :any_skip_relocation, ventura:        "455c2c8e9e4e48ac27d7cb7890434915cafdcb7eea455df90f49814fc10785fb"
    sha256 cellar: :any_skip_relocation, monterey:       "03b7ecbfde7230bb19eab4feffc04df62c2f7ae75b4ee8b6bf6dd42d15e1e3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6991bc1ff93937e98dd379cfe0196eacec1b932a1b6a3a1f0d245c314d5774"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
