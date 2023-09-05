class Amfora < Formula
  desc "Fancy terminal browser for the Gemini protocol"
  homepage "https://github.com/makeworld-the-better-one/amfora"
  url "https://github.com/makeworld-the-better-one/amfora.git",
      tag:      "v1.9.2",
      revision: "61d864540140f463a183e187e4211c258bd518bf"
  license all_of: [
    "GPL-3.0-only",
    any_of: ["GPL-3.0-only", "MIT"], # rr
  ]
  head "https://github.com/makeworld-the-better-one/amfora.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "076083a307b78e2bdd5e4895ebc38330e076b473762322a063fcce004f664f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01501f81b2ededf595e98e5a36ab17f87dc8a21fa7cb29c76a17497ca33ae8f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "082d3f24c6c13351effa01f68e819b18f7bbf5767c5a106e18ea430c5f880bce"
    sha256 cellar: :any_skip_relocation, ventura:        "fd8068eca6705c1c22b96e1cdb0de4ef064300cfb101f77c9710e3ace99a7787"
    sha256 cellar: :any_skip_relocation, monterey:       "a7edc527c8c5e5d8d177a557d83b5016b67a09f95e2263c20afb2bfacaea6697"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec71320ee1101a0226f18fb2c6796c96ee5bcd25928e0443c645a8eb1d3065db"
    sha256 cellar: :any_skip_relocation, catalina:       "47bc30b0e91888d9a0b0581ff4006654b9f59f860226a70cef809fa15145877f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3030cd52c16fd0917db9f0283bf51853b12569ee0bf0ab88ed0625e3b43d4c1d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    pkgshare.install "contrib/themes"
  end

  test do
    require "open3"

    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts "env TERM=xterm #{bin}/amfora"
    sleep 1
    input.putc "1"
    sleep 1
    input.putc "1"
    sleep 1
    input.putc "q"

    screenlog = (testpath/"screenlog.txt").read
    assert_match "# New Tab", screenlog
    assert_match "## Learn more about Amfora!", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
