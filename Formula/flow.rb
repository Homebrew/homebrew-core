class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.210.1.tar.gz"
  sha256 "ddcdee46a1c122a6ea8b0e97f0e118077b3ee2f1880532a4a505700af336290f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdaba2a12c6f2d753df3da9dd5b5526f888b292228c32db68e4f59726ab47de6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "340f3cd03d3030573db38cbc5f0893daf4d628448cb06d0a38cdbb250a266a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd630df9414affe2d6da65f3a71c1d575d6a786c0f2aacee420138f21420929a"
    sha256 cellar: :any_skip_relocation, ventura:        "a9829f571989148b7a1a442f078201474941a47f548826584e2fb58f4d8f0484"
    sha256 cellar: :any_skip_relocation, monterey:       "438f962a518ebc7fa5c89c94edc7fdc9fffab97290c38344969d248b91ba8c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa7702fcad6fe264d9054a0f039556ab9866378ab69d3a4c2902d1bfbd6d06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "813556e0695fa21cf2c376618fb7f7038dcd56aaa382bb9339cffc45149652e8"
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
