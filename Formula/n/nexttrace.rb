class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/nxtrace/NTrace-core"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.2.0.tar.gz"
  sha256 "1bf4b23c8ae96bd0e084d15f107c35563954a268a1d3fd222fcdad77c873741f"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bad99ef0bdc92c81daea53db2bab5c67dda2916862067c6a18f7a41ad0b1c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d9c62b6d483c1e791f6b495a89ac6c35bcbfa6a52391ebde7369b6d28a054c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd35b50419177b57070541dcea1bf1ed9f99327bc1fd6b496132ca6a9e63a03d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b7571f40b7cdfc2211d56a67006d09c0bf56332e66486d50b042376ffea38aa"
    sha256 cellar: :any_skip_relocation, ventura:        "f51b1cc26e668ddb202fe640281256c37381fffc12e4ce1d863f6794474c8500"
    sha256 cellar: :any_skip_relocation, monterey:       "8f3afaa69a8059a5072c326738f343d55b06e41eb50c6ea4ce122081c85a9dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea8758a02c0c477b54029694b6db324685d2cace5f6708c3f8e4ca29d2b7f45"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = shell_output(bin/"nexttrace --language en 1.1.1.1 2>&1", 1)
    assert_match "traceroute to 1.1.1.1", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
