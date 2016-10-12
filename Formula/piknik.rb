class Piknik < Formula
  desc "Copy/paste anything over the network"
  homepage "https://github.com/jedisct1/piknik"
  url "https://github.com/jedisct1/piknik/archive/0.9.1.tar.gz"
  sha256 "a682e16d937a5487eda5b0d0889ae114e228bd3c9beddd743cad40f1bad94448"
  head "https://github.com/jedisct1/piknik.git"

  bottle do
    sha256 "a5b6ec2bcfaaf4fd7d4770f989f002a3e8e5bc599bf098bbcaff8afd9356a751" => :sierra
    sha256 "18dffa6ad73f2148f443167e1678a86b62fabf29ae2a5a97b51bea95814a0752" => :el_capitan
    sha256 "1af1d28a88b23bd23c098e3410c26ed79ad05ac0cf42ded7831f773dee46a27a" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/jedisct1/"
    dir.install Dir["*"]
    ln_s buildpath/"src", dir
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"piknik", "."
      (prefix/"etc/profile.d").install "zsh.aliases" => "piknik.sh"
      prefix.install_metafiles
    end
  end

  def caveats; <<-EOS.undent
    In order to get convenient shell aliases, put something like this in #{shell_profile}:
      source "$(brew --prefix)/etc/profile.d/piknik.sh"
    EOS
  end

  test do
    conffile = testpath/"testconfig.toml"

    genkeys = shell_output("#{bin}/piknik -genkeys")
    lines = genkeys.lines.grep(/\s+=\s+/).map { |x| x.gsub(/\s+/, " ").gsub(/#.*/, "") }.uniq
    conffile.write lines.join("\n")
    pid = fork do
      exec "#{bin}/piknik", "-server", "-config", conffile
    end
    begin
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-copy"], "w+") do |p|
        p.write "test"
      end
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-move"], "r") do |p|
        clipboard = p.read
        assert_equal clipboard, "test"
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      conffile.unlink
    end
  end
end
