class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "57965af14e2579ea44928070aa04251ecbb1fb4e206c208b4aec6f803ca36b5a"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1edebe84ce6dcdae801c7d28ad8263f987fd4d48022740d346c2ecaac34b5eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1edebe84ce6dcdae801c7d28ad8263f987fd4d48022740d346c2ecaac34b5eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1edebe84ce6dcdae801c7d28ad8263f987fd4d48022740d346c2ecaac34b5eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee89cad59b8d0160ad4db0d952d2e248c06b49caefe13a27215ed46fb8d9aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c831d12b3ab8433c0c65c711e3585f07362af43e768ab96c144b78207e722971"
    sha256 cellar: :any,                 x86_64_linux:  "da1a02a4172d44c524d712ca534d1d923c6cd84176d20ade28b5a6c1ba064308"
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
