class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.214.0.tar.gz"
  sha256 "f8ed1d9c3316e983fad2c3a250ccc2fe49e8d5a2ca606e6c465d831e7c7a31bf"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d2ba582a87ebcce7c915f854cf346656054b50eec040c33ca5cfd3bd5c23da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e421acff8428835572a2fd9b88c5715b1c020abb0df147c58d75d029b3786c6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f665735858e2477d52660ef01491cda2f231be315a72f092167843729a0ee9a5"
    sha256 cellar: :any_skip_relocation, ventura:        "951120cf8aea6b0844285ec479ef720b3cf02884ea50c38ddd683c3652b99adb"
    sha256 cellar: :any_skip_relocation, monterey:       "2312f374be9fc29ebf3f6a7394a07f82a65237194c8fb17521bc504af3bd4829"
    sha256 cellar: :any_skip_relocation, big_sur:        "46878a13ec0f3b97b7ba41acdf267cdc874f976487ed756cafdad7ec6bb3ece9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea50448b2e85f3f8e30f913799a176c41fd167e2186bbe06bb3584c30397c52d"
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
