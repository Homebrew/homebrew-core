class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.19.4.tar.gz"
  sha256 "5f6ed78562e4e9c74a5890f1599b2b137da1b2f3a1032125de9baeddcc0546a4"
  license "BSD-3-Clause"

  depends_on "rust" => :build

  def install
    cd "bkmr" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test bkmr`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    assert_match "bkmr", shell_output("#{bin}/bkmr --help")
  end
end
