class Ijq < Formula
  desc "Interactive jq"
  homepage "https://codeberg.org/gpanders/ijq"
  url "https://codeberg.org/gpanders/ijq/archive/v1.3.0.tar.gz"
  sha256 "904391d8cf6c803fe7abbdacccac13a9e477c7b7768cc956ed1b61de9bc125f4"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/gpanders/ijq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb7cdcd12cc01a149299ecd804b843f352f6fe59820336ab975531a9dcb090c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b719b970e1e51d0575cd3b5d9a010cbf8ad5f34fcb1807a80a3b612d46f7b2d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857bb065a4587f93bdd317a4d43796ad40241fa6c31dfb8d07f9b62ea1b83345"
    sha256 cellar: :any_skip_relocation, sonoma:        "65732ba712075ad3e235273c31aaabcca9289d43914681a7d5a4616e36d243bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e01250f8e87643513b823aa0ac5602c203f6a413c4cdd522aaa15b28e0aaae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec141c344bbab2f81d9542b2e1fd49457a3625ab8d4ab85e3825e213f6b87a6e"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'

    require "expect"
    require "pty"
    PTY.spawn("#{bin}/ijq -H '' -M -n -f filterfile.jq > result") do |r, w, pid|
      refute_nil r.expect("barbazfoo", 5), "Expected barbazfoo"
      w.write "\r"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_equal "\"barbazfoo\"\n", (testpath/"result").read
  end
end
