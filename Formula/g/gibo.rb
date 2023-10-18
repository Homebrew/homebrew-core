class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/v3.0.7.tar.gz"
  sha256 "1e07ca4d5e7a0303784c42c5c9633b63cc0532d5b9dc69e7400caa501be51497"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc9a70a4b9234a386cdafbc25c18d871b6a03a4cc175d17951183e3cee2f1e67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c39916cb2044cf8862b62b165f262b6a357cd0cf73c6e48a9a9b00d897606ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c39916cb2044cf8862b62b165f262b6a357cd0cf73c6e48a9a9b00d897606ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c39916cb2044cf8862b62b165f262b6a357cd0cf73c6e48a9a9b00d897606ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "18054c169300316a66bd57f84401d42d31096b752f89cf85327b62269c69ed65"
    sha256 cellar: :any_skip_relocation, ventura:        "0298262a6c11885b4777c350565df41865b71dbbdcecb037370e3ca0e0a42464"
    sha256 cellar: :any_skip_relocation, monterey:       "0298262a6c11885b4777c350565df41865b71dbbdcecb037370e3ca0e0a42464"
    sha256 cellar: :any_skip_relocation, big_sur:        "0298262a6c11885b4777c350565df41865b71dbbdcecb037370e3ca0e0a42464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b4c3bffaa2cdfb2fc0c5076b13f73315f98c7ebd4e1e915ec5f0780cdc593c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
