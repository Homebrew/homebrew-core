class CedraCli < Formula
  desc "CLI for a Cedra blockchain"
  homepage "https://github.com/Username/homebrew-cedra-cli"
  url "https://github.com/cedra-labs/cedra/releases/download/cedra-cli-v7.3.1/cedra-cli-7.3.1-macOS-x86_64.zip"
  sha256 "sha256:7ba7fc9857ebb2da994bbf21300018553e3b7593d0b7608058ca9e3fdc82b835"
  license ""

  depends_on "rust" => :build

def install
  system "cargo", "install", *std_cargo_args
end

test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test homebrew-cli`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
