class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "0488bc0717a1becda77fe1094a5eb4972ef1b6cd335f4108ddbbf89c6f917410"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135fdf1a0b34d87659f430d7be2f552062cd15982bba236d1741bee4ba5a4675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135fdf1a0b34d87659f430d7be2f552062cd15982bba236d1741bee4ba5a4675"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "135fdf1a0b34d87659f430d7be2f552062cd15982bba236d1741bee4ba5a4675"
    sha256 cellar: :any_skip_relocation, sonoma:        "f762cd5fa3143bcf4cb16bb8495b5a007d88335b117eaa537676bb23ee41d3fe"
    sha256 cellar: :any_skip_relocation, ventura:       "f762cd5fa3143bcf4cb16bb8495b5a007d88335b117eaa537676bb23ee41d3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bcf9a9430011265aaa5b98175f8dc1c3cf2d73e3034f719d175567bcf549126"
  end

  depends_on "go" => :build

  def install
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    bash_completion.install "completion.d/aptly"
    zsh_completion.install "completion.d/_aptly"

    man1.install "man/aptly.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aptly version")

    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
