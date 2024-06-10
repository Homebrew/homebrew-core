class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.237.2.tar.gz"
  sha256 "d18ff5900898ec4304c54129e0493cf198db2e5b10e91f25273348e93741a5f0"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e7379781db1a05106ef8a0f99e06b301271e73dd0543c5a92dd241ef2491b96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cb0aa26aef6ddecdb9e0e2e8c2b6282ac9e6b38106bbac7fe174e1b1e9f4c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ebdedf128534a36fd90e7a7ffcb901230d59529e4b08937bf72ae3fdaa0095d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dd72d7dc95cda8a987e4cf4b39502a9a9f96c78c650f7dc94a8b4d99ab9aa47"
    sha256 cellar: :any_skip_relocation, ventura:        "e4e1ef11c58f64c8b33d65573c66c5eee820f68ebbc9836ecd88d05a6887527d"
    sha256 cellar: :any_skip_relocation, monterey:       "7252a6e9dce8deeb81730c78771dec2a0fbd10069a598a6b683a2b9945362175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbbfeeebb4fa2c117f2097b05bba2961992946d3c09c1df03da54c5edc535112"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
