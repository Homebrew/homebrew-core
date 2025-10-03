class Msedit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e4ba6ff1bfecfeff2492306f5850c714bf50ffdb3cc3bb5be3aa987289f240fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5e47e81d4b0f09ecf3668357290c1ab327e07e3c48b26523b307a24dfd11170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85957f070c49135a21ed0bf51a56bbd70d96903811ae1cc4bc932373407b63d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f78eba707fee6f5ddddc0038996738ca723cdf22586636da15ed3121583f79"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7ad8fbbe96effc0b3aa6852a58743af226dff0b028f0cef15428e4987af52e5"
  end

  depends_on "rust" => :build
  depends_on :macos # due to test failure on linux

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    # msedit is a TUI application
    assert_match version.to_s, shell_output("#{bin}/edit --version")
  end
end
