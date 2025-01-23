class Amfora < Formula
  desc "Fancy terminal browser for the Gemini protocol"
  homepage "https://github.com/makew0rld/amfora"
  url "https://github.com/makew0rld/amfora/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0bc9964ccefb3ea0d66944231492f66c3b0009ab0040e19cc115d0b4cd9b8078"
  license all_of: [
    "GPL-3.0-only",
    any_of: ["GPL-3.0-only", "MIT"], # rr
  ]
  head "https://github.com/makew0rld/amfora.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d5ca2d3a6e2ceff7b959b5dbcb46fce4ae8fc906ad17d6ae3c56dca81c52cf44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5ec84d2286802f8cb76b710ced58fe9d19569a77e52f42390fac1d1ecc89b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97625ffb788e518429183d5c525d8229fa85c2f1bc266d4532505734a378bcba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c656b1fe13604e4109727095549cf411fdad31957c2ffe7d134f41495fec011f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f65bdde1720c9119b9977cde1811d6af3b8cfc879d5189f6693bb87e998341e5"
    sha256 cellar: :any_skip_relocation, ventura:        "714e7f2580f209650fa0a9f5002708dc84493bae28a4239156d3ff7108fe5fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "9f519ca531d13326ca451a7f8fca211522102223192f7f3427ba4d94ca29f34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2bc8d37b87dd964a2a4c8fe0c9b79406d2adc593edf7a565473190e59929f97"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=homebrew"
    system "go", "build", *std_go_args(ldflags:)
    pkgshare.install "contrib/themes"
  end

  test do
    ENV["TERM"] = "xterm"

    require "open3"

    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts bin/"amfora"
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
