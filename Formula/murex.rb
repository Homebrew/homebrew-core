class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.11.2200.tar.gz"
  sha256 "31930f6ddc1b44a08352e79b8b6afdca2b47ce6e30057e839ccfe06f68a45fe9"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d08fcf50769e9cdac901df8d32cdc4f359bb0a3c5bbbe748a722577c27314585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6794ce337fad1a0ed3688c6ad10a48ca04b0355fd1c0a02c3a9ed0ed0811254"
    sha256 cellar: :any_skip_relocation, monterey:       "50a535a88c0ceb2577007ab98e72c156e5ffa96d524b122ff189065af4d2df48"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ef896f7943bbddf7a0253549d6248c9bfc100978d4b2d519f55f969703041fc"
    sha256 cellar: :any_skip_relocation, catalina:       "e19d73d4980d8228df554a63fce716afb8c4a85741744f8c943fe9d48f4ecdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59774d034513288a89d2ebc53c95bb060be80acfc6419dcc84ff290303cce196"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
