class FastCli < Formula
  desc "Command-line version of fast.com"
  homepage "https://github.com/mikkelam/fast-cli"
  url "https://github.com/mikkelam/fast-cli/archive/refs/tags/0.0.2.tar.gz"
  sha256 "28b86b8c4cdefc86de4e0e124166cef010a7d1d00cdeee4d4beb17cab4717230"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    dir = buildpath/"src/github.com/mikkelam/fast-cli"
    dir.install buildpath.children

    cd dir do
      with_env(
        "VERSION" => version.to_s,
        "COMMIT"  => "homebrew",
        "DATE"    => Time.now.utc.iso8601,
      ) do
        system "go", "mod", "tidy"
        system "make", "build"
      end
      bin.install "fast-cli"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast-cli --version")

    output = shell_output("#{bin}/fast-cli --help")
    assert_match "Estimate connection speed using fast.com", output
  end
end
