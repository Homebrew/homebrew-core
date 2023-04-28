class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "098bb18e1cae42ab7597b6b442538d3f51b57935a848ea121e20e2921d6a4693"
  license "Apache-2.0"

  # Cmake is here as only rust install wasn't enough
  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test gitoxide`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
