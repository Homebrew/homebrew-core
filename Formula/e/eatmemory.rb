class Eatmemory < Formula
  desc "Simple program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1cbd585adcf014beaecd442454f15eeac8364eab12dde39593acc0a503b41223"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e32821696c3aeb3cb91bdfb6a7d6ce946b837707dd4133afa4e3b5b87bf6d25e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f38c05758f9191f81ab04d306987795e6914885ceb9a117d9df8d8aff339978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49b3e405a71bf5cb46a235fe205026dc7d49a6398f9803ea5c023a5ad1907490"
    sha256 cellar: :any_skip_relocation, sonoma:        "d93af56efb77ba21a8e17d99233ca23533878548ed8e839143b61705460e69dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "483704f7109db706fd34730559b2b822ab9a64eddb2992fd725098535ff38b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f533d0610753efd7d0be2492b438403b65ba8ddcf7a26cd64733cca2a69cacf4"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    assert_match "eatmemory #{version}", shell_output("#{bin}/eatmemory --help")

    out = shell_output("#{bin}/eatmemory -t 0 10M")
    assert_match(/^Eating .+ in chunks of .+\.\.\.$/, out)
    assert_match(/^Done, sleeping for 0 seconds before exiting\.\.\.$/, out)

    pid = spawn bin/"eatmemory", "-t", "60", "10M", [:out, :err] => File::NULL
    sleep 5

    rss_kb = shell_output("ps -o rss= -p #{pid}").to_i
    assert_operator rss_kb, :>=, 10 * 1024
    assert_operator rss_kb, :<, 20 * 1024
  ensure
    if pid
      begin
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
    end
  end
end
