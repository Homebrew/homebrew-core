# ooshare — homebrew-core formula (source build)
#
# This formula builds ooshare from source (Go) per homebrew-core policy,
# unlike the tap formula which installs a prebuilt binary.
# Submit to Homebrew/homebrew-core at Formula/o/ooshare.rb.

class Ooshare < Formula
  desc "One-time secret sharing from the terminal, end-to-end encrypted"
  homepage "https://ooshare.io"
  url "https://github.com/dhdtech/ooshare.io/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "a9340aef2475e9e5b138e938b70623270f0fa3ca4f1acd54f01759c4d85c745c"
  license "MIT"

  depends_on "go" => :build

  def install
    cd "cli" do
      system "go", "build", *std_go_args(output: bin/"ooshare",
        ldflags: "-s -w -X github.com/dhdtech/ooshare.io/cli/internal/cli.Version=#{version}")
    end
  end

  test do
    assert_match "ooshare", shell_output("#{bin}/ooshare --help")
  end
end
