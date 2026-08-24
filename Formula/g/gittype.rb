class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "0a07bba8acc5bd95b0dfe2212c1f220abfb5181782502feecaaab14a5cccb6d5"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25786eb5e9a1431d0a3c654794be20e0add8e415ff138add4b28d5cb7ba5e64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a5be98c0648d29b245eaf21bf5c53d2eca1df28924f3997e07b142fa984f503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9f4c8ecd3da5106b6abac736660b4bb01de10aa0559ecece51b67df1e099e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c769693c7288944e0a47f76c58e26c21bee74afaef9a688f1b7204c4225368b"
    sha256 cellar: :any,                 arm64_linux:   "eca2aece39f389743868cc80d7b2ceb6abae3756fe2a2a1fd01b27e61b059664"
    sha256 cellar: :any,                 x86_64_linux:  "17c440e6cb4e53556dec56d694c46785c17a7530d23156c9bb74b02b009e7d46"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end
