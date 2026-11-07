class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "37906bd07ac29776699e4ecc0e5e7192744ae13ad19a35b0ed956b0893f4589b"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8e727cb597ad932cc1fa20df63d85282b0e319e957272fd54c742c0eafcdc9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8e727cb597ad932cc1fa20df63d85282b0e319e957272fd54c742c0eafcdc9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8e727cb597ad932cc1fa20df63d85282b0e319e957272fd54c742c0eafcdc9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd4531594ed531ee84d30f35e6f2395e5710631916fd67feb6ac6691e1912ba9"
    sha256 cellar: :any,                 x86_64_linux:      "35ec27e71dfe8a968ea56e3c28bae462a489badd816b75d483bdc0da731dd227"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
