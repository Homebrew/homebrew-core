class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "689a0b4f110ab2528ae271c3884b92304e0fdf7a3bf4ee93f60705f4a27d4952"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38fc5f4613ad94e1683a9811b56dcc872ae1891a00a4cf50c030504b1b1b65c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38fc5f4613ad94e1683a9811b56dcc872ae1891a00a4cf50c030504b1b1b65c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38fc5f4613ad94e1683a9811b56dcc872ae1891a00a4cf50c030504b1b1b65c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5280808fdfcc9655b52b5752b94a506cc61f10892db5c0cfb90765eb7d87710a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d68d5c7057f0912267b7b74a9a4d6b05eeae67d9ed654510d1412570e91618d2"
    sha256 cellar: :any,                 x86_64_linux:  "9649c7440236ca5b77425d36e6c894a2a51d745a8d5f4599f833df4ea8ce3e14"
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
